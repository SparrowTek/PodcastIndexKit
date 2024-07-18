@preconcurrency import Foundation

@PodcastActor
class DownloadService: Sendable {
    public init() {}
    
    public func downloadEpisode(from url: String) async throws -> Data {
        guard let url = URL(string: url) else { throw NetworkError.missingURL }
        let request = URLRequest(url: url)
        guard let (data, response) = try? await URLSession.shared.data(for: request, delegate: nil) else { throw NetworkError.noData }
        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.noStatusCode }
        switch httpResponse.statusCode {
        case 200...299:
            return data
        default:
            throw NetworkError.noData
        }
    }
}
