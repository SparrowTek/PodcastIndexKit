@preconcurrency import Foundation
import os.log

@PodcastActor
public final class DownloadService: NSObject {
    public static let shared = DownloadService()
    private typealias ContinuationID = UUID
    private static let sessionIdentifier = "com.sparrowtek.podcastindexkit.background-downloads"
    private let logger = Logger(subsystem: "com.sparrowtek.podcastindexkit", category: "DownloadService")
    private let fileManager = FileManager()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let downloadsDirectory: URL
    private let stateURL: URL
    private let pendingCompletionURL: URL
    private lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: Self.sessionIdentifier)
        configuration.allowsCellularAccess = true
        configuration.isDiscretionary = false
        configuration.sessionSendsLaunchEvents = true
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    private var downloads: [Int: ManagedDownload] = [:]
    private var pendingCompletions: [PendingCompletion] = []
    private var continuations: [ContinuationID: AsyncStream<Event>.Continuation] = [:]
    private var backgroundCompletionHandlers: [String: () -> Void] = [:]

    private override init() {
        let baseDirectory = DownloadService.makeBaseDirectory()
        downloadsDirectory = baseDirectory.appendingPathComponent("Downloads", isDirectory: true)
        stateURL = baseDirectory.appendingPathComponent("downloads-state.json")
        pendingCompletionURL = baseDirectory.appendingPathComponent("pending-completions.json")
        super.init()
        createDirectoriesIfNeeded()
        loadPersistedDownloads()
        loadPendingCompletions()
        Task { [weak self] in
            await self?.restoreOutstandingTasks()
        }
    }

    deinit {
        continuations.values.forEach { $0.finish() }
    }

    // MARK: - Public API
    public func enqueue(_ episode: Episode) async throws {
        guard let episodeID = episode.id else { throw DownloadError.missingIdentifier }
        guard let urlString = episode.enclosureUrl, let url = URL(string: urlString) else { throw DownloadError.missingURL }
        guard downloads[episodeID] == nil else { return }

        let destinationName = destinationFilename(for: episode, remoteURL: url)
        var record = ManagedDownload(episode: episode,
                                     fileName: destinationName,
                                     bytesExpected: episode.enclosureLength.map(Int64.init) ?? NSURLSessionTransferSizeUnknown)
        downloads[episodeID] = record
        persistDownloads()

        let task = urlSession.downloadTask(with: URLRequest(url: url))
        task.taskDescription = taskDescription(forEpisodeID: episodeID)
        record.taskIdentifier = task.taskIdentifier
        downloads[episodeID] = record
        persistDownloads()
        task.resume()
        broadcast(.started(episode))
    }

    public func cancelDownload(forEpisodeID episodeID: Int) async {
        let episode = downloads[episodeID]?.episode
        let task = await taskForEpisodeID(episodeID)
        task?.cancel()
        downloads.removeValue(forKey: episodeID)
        persistDownloads()
        if let episode { broadcast(.cancelled(episode)) }
    }

    public func cancelAllDownloads() async {
        let snapshot = downloads
        downloads.removeAll()
        persistDownloads()
        let tasks = await fetchAllDownloadTasks()
        tasks.forEach { $0.cancel() }
        for episode in snapshot.values.map({ $0.episode }) {
            broadcast(.cancelled(episode))
        }
    }

    public func activeDownloads() async -> [ActiveDownloadSnapshot] {
        downloads.values.map { $0.snapshot(root: downloadsDirectory) }
    }

    public func pendingCompletions() async -> [Completion] {
        pendingCompletions.map { Completion(episode: $0.episode,
                                            fileURL: downloadsDirectory.appendingPathComponent($0.fileName, isDirectory: false),
                                            bytesExpected: $0.bytesExpected,
                                            fileSize: $0.fileSize) }
    }

    public func acknowledgeCompletion(at fileURL: URL) async {
        let fileName = fileURL.lastPathComponent
        let countBefore = pendingCompletions.count
        pendingCompletions.removeAll { $0.fileName == fileName }
        if countBefore != pendingCompletions.count {
            persistPendingCompletions()
        }
    }

    public func handleBackgroundEvents(for identifier: String, completionHandler: @escaping () -> Void) async {
        guard identifier == Self.sessionIdentifier else {
            completionHandler()
            return
        }
        backgroundCompletionHandlers[identifier] = completionHandler
    }

    public func makeEventsStream() async -> AsyncStream<Event> {
        AsyncStream { continuation in
            let id = ContinuationID()
            continuation.onTermination = { [weak self] _ in
                Task { await self?.removeContinuation(id) }
            }
            
            addContinuation(id, continuation: continuation)
        }
    }

    // MARK: - Events
    private func addContinuation(_ id: ContinuationID, continuation: AsyncStream<Event>.Continuation) {
        continuations[id] = continuation
    }

    private func removeContinuation(_ id: ContinuationID) {
        continuations.removeValue(forKey: id)
    }

    private func broadcast(_ event: Event) {
        continuations.values.forEach { $0.yield(event) }
    }

    // MARK: - Background session helpers
    private func restoreOutstandingTasks() async {
        let tasks = await fetchAllDownloadTasks()
        var seenEpisodeIDs = Set<Int>()
        for task in tasks {
            guard let episodeID = episodeID(for: task.taskDescription) else {
                task.cancel()
                continue
            }
            seenEpisodeIDs.insert(episodeID)
            guard var record = downloads[episodeID] else {
                task.cancel()
                continue
            }
            record.taskIdentifier = task.taskIdentifier
            downloads[episodeID] = record
            if task.state == .suspended {
                task.resume()
            }
        }

        let staleIDs = downloads.keys.filter { !seenEpisodeIDs.contains($0) }
        staleIDs.forEach { downloads.removeValue(forKey: $0) }
        persistDownloads()
    }

    private func fetchAllDownloadTasks() async -> [URLSessionDownloadTask] {
        await withCheckedContinuation { continuation in
            urlSession.getAllTasks { tasks in
                let downloads = tasks.compactMap { $0 as? URLSessionDownloadTask }
                continuation.resume(returning: downloads)
            }
        }
    }

    private func taskForEpisodeID(_ episodeID: Int) async -> URLSessionDownloadTask? {
        let tasks = await fetchAllDownloadTasks()
        return tasks.first { $0.taskDescription == "/(episodeID)" } // episodeID(for: $0.taskDescription) == episodeID } RADEMAKER
    }

    // MARK: - Persistence helpers
    private func createDirectoriesIfNeeded() {
        do {
            try fileManager.createDirectory(at: downloadsDirectory, withIntermediateDirectories: true)
        } catch {
            logger.error("Failed to create downloads directory: \(error.localizedDescription)")
        }
    }

    private func loadPersistedDownloads() {
        guard fileManager.fileExists(atPath: stateURL.path) else { return }
        do {
            let data = try Data(contentsOf: stateURL)
            let persisted = try decoder.decode([Int: PersistedDownload].self, from: data)
            downloads = persisted.mapValues { ManagedDownload(persisted: $0) }
        } catch {
            logger.error("Failed to load persisted downloads: \(error.localizedDescription)")
            downloads = [:]
        }
    }

    private func persistDownloads() {
        do {
            let data = try encoder.encode(downloads.mapValues { $0.persisted })
            try data.write(to: stateURL, options: [.atomic])
        } catch {
            logger.error("Failed to persist downloads: \(error.localizedDescription)")
        }
    }

    private func loadPendingCompletions() {
        guard fileManager.fileExists(atPath: pendingCompletionURL.path) else { return }
        do {
            let data = try Data(contentsOf: pendingCompletionURL)
            pendingCompletions = try decoder.decode([PendingCompletion].self, from: data)
        } catch {
            logger.error("Failed to load pending completions: \(error.localizedDescription)")
            pendingCompletions = []
        }
    }

    private func persistPendingCompletions() {
        do {
            let data = try encoder.encode(pendingCompletions)
            try data.write(to: pendingCompletionURL, options: [.atomic])
        } catch {
            logger.error("Failed to persist pending completions: \(error.localizedDescription)")
        }
    }

    // MARK: - Delegate helpers

    private func handleBackgroundURLSessionFinished() async {
        let handler = backgroundCompletionHandlers.removeValue(forKey: Self.sessionIdentifier)
        handler?()
    }

    private func handleDownloadFinished(taskDescription: String?, location: URL) async {
        guard let episodeID = episodeID(for: taskDescription), let record = downloads[episodeID] else {
            cleanupTemporaryFile(at: location)
            return
        }

        let destination = record.destinationURL(root: downloadsDirectory)
        do {
            if fileManager.fileExists(atPath: destination.path) {
                try fileManager.removeItem(at: destination)
            }
            try fileManager.moveItem(at: location, to: destination)
            let attributes = try fileManager.attributesOfItem(atPath: destination.path)
            let fileSize = (attributes[.size] as? NSNumber)?.int64Value ?? 0
            let payload = PendingCompletion(episode: record.episode,
                                            fileName: record.fileName,
                                            bytesExpected: record.bytesExpected,
                                            fileSize: fileSize)
            pendingCompletions.append(payload)
            persistPendingCompletions()
            downloads.removeValue(forKey: episodeID)
            persistDownloads()
            let completion = Completion(episode: payload.episode,
                                        fileURL: destination,
                                        bytesExpected: payload.bytesExpected,
                                        fileSize: payload.fileSize)
            broadcast(.completed(completion))
        } catch {
            logger.error("Failed to finalize download for episode \(episodeID): \(error.localizedDescription)")
            broadcast(.failed(Failure(episode: record.episode, message: error.localizedDescription)))
        }
    }

    private func handleProgress(taskDescription: String?, bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpected: Int64) async {
        guard let episodeID = episodeID(for: taskDescription), var record = downloads[episodeID] else { return }
        record.bytesReceived = totalBytesWritten
        if totalBytesExpected > 0 {
            record.bytesExpected = totalBytesExpected
        }
        downloads[episodeID] = record
        persistDownloads()
        let progress = Progress(episode: record.episode,
                                bytesReceived: totalBytesWritten,
                                bytesExpected: record.bytesExpected)
        broadcast(.progress(progress))
    }

    private func handleTaskCompletion(taskDescription: String?, errorCode: Int, errorMessage: String?) async {
        guard let episodeID = episodeID(for: taskDescription), let record = downloads[episodeID] else { return }
        downloads.removeValue(forKey: episodeID)
        persistDownloads()
        if errorCode == NSURLErrorCancelled {
            broadcast(.cancelled(record.episode))
            return
        }
        let message = errorMessage ?? "Unknown error"
        broadcast(.failed(Failure(episode: record.episode, message: message)))
    }

    private func cleanupTemporaryFile(at url: URL) {
        do {
            try fileManager.removeItem(at: url)
        } catch {
            logger.error("Failed to remove temp download: \(error.localizedDescription)")
        }
    }

    private func taskDescription(forEpisodeID episodeID: Int) -> String {
        "episode-\(episodeID)"
    }

    private func episodeID(for description: String?) -> Int? {
        guard let description, description.hasPrefix("episode-"), let value = Int(description.dropFirst("episode-".count)) else { return nil }
        return value
    }

    private func destinationFilename(for episode: Episode, remoteURL: URL) -> String {
        let identifier = episode.id.map(String.init) ?? UUID().uuidString
        let ext = resolvedExtension(for: episode, remoteURL: remoteURL)
        return "episode-\(identifier).\(ext)"
    }

    private func resolvedExtension(for episode: Episode, remoteURL: URL) -> String {
        if !remoteURL.pathExtension.isEmpty {
            return remoteURL.pathExtension.lowercased()
        }
        guard let mimeType = episode.enclosureType?.lowercased() else { return "bin" }
        if mimeType.contains("mp3") { return "mp3" }
        if mimeType.contains("aac") { return "aac" }
        if mimeType.contains("m4a") { return "m4a" }
        if mimeType.contains("ogg") { return "ogg" }
        if mimeType.contains("opus") { return "opus" }
        return "bin"
    }

    private static func makeBaseDirectory() -> URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first ?? FileManager.default.temporaryDirectory
        return appSupport.appendingPathComponent("com.sparrowtek.podcastindexkit", isDirectory: true)
    }
}

// MARK: - URLSessionDownloadDelegate
extension DownloadService: URLSessionDownloadDelegate {
    nonisolated public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let description = downloadTask.taskDescription
        Task { await self.handleDownloadFinished(taskDescription: description, location: location) }
    }

    nonisolated public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let description = downloadTask.taskDescription
        Task { await self.handleProgress(taskDescription: description,
                                         bytesWritten: bytesWritten,
                                         totalBytesWritten: totalBytesWritten,
                                         totalBytesExpected: totalBytesExpectedToWrite) }
    }
}

extension DownloadService: URLSessionTaskDelegate {
    nonisolated public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        guard let error else { return }
        let description = task.taskDescription
        Task { await self.handleTaskCompletion(taskDescription: description,
                                               errorCode: (error as NSError).code,
                                               errorMessage: error.localizedDescription) }
    }

    nonisolated public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        guard session.configuration.identifier == Self.sessionIdentifier else { return }
        Task { [weak self] in
            await self?.handleBackgroundURLSessionFinished()
        }
    }
}

// MARK: - Supporting Types
public extension DownloadService {
    enum DownloadError: LocalizedError {
        case missingIdentifier
        case missingURL

        public var errorDescription: String? {
            switch self {
            case .missingIdentifier:
                return "Episode is missing a stable identifier."
            case .missingURL:
                return "Episode is missing a valid enclosure URL."
            }
        }
    }

    struct Progress: Sendable {
        public let episode: Episode
        public let bytesReceived: Int64
        public let bytesExpected: Int64

        public var fractionCompleted: Double {
            guard bytesExpected > 0 else { return 0 }
            return Double(bytesReceived) / Double(bytesExpected)
        }
    }

    struct Completion: Sendable {
        public let episode: Episode
        public let fileURL: URL
        public let bytesExpected: Int64
        public let fileSize: Int64
    }

    struct Failure: Sendable {
        public let episode: Episode
        public let message: String
    }

    struct ActiveDownloadSnapshot: Sendable {
        public let episode: Episode
        public let destinationURL: URL
        public let bytesReceived: Int64
        public let bytesExpected: Int64

        public var fractionCompleted: Double {
            guard bytesExpected > 0 else { return 0 }
            return Double(bytesReceived) / Double(bytesExpected)
        }
    }

    enum Event: Sendable {
        case started(Episode)
        case progress(Progress)
        case completed(Completion)
        case failed(Failure)
        case cancelled(Episode)
    }
}

private struct ManagedDownload: Codable, Sendable {
    var episode: Episode
    var fileName: String
    var bytesReceived: Int64
    var bytesExpected: Int64
    var taskIdentifier: Int?

    init(episode: Episode, fileName: String, bytesExpected: Int64) {
        self.episode = episode
        self.fileName = fileName
        self.bytesReceived = 0
        self.bytesExpected = bytesExpected
        self.taskIdentifier = nil
    }

    init(persisted: PersistedDownload) {
        self.episode = persisted.episode
        self.fileName = persisted.fileName
        self.bytesReceived = 0
        self.bytesExpected = persisted.bytesExpected
        self.taskIdentifier = nil
    }

    func destinationURL(root: URL) -> URL {
        root.appendingPathComponent(fileName, isDirectory: false)
    }

    func snapshot(root: URL) -> DownloadService.ActiveDownloadSnapshot {
        DownloadService.ActiveDownloadSnapshot(episode: episode,
                                               destinationURL: destinationURL(root: root),
                                               bytesReceived: bytesReceived,
                                               bytesExpected: bytesExpected)
    }

    var persisted: PersistedDownload {
        PersistedDownload(episode: episode, fileName: fileName, bytesExpected: bytesExpected)
    }
}

private struct PersistedDownload: Codable, Sendable {
    let episode: Episode
    let fileName: String
    let bytesExpected: Int64
}

private struct PendingCompletion: Codable, Sendable {
    let episode: Episode
    let fileName: String
    let bytesExpected: Int64
    let fileSize: Int64
}
