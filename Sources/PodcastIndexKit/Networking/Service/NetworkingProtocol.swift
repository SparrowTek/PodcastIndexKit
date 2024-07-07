@preconcurrency import Foundation

@PodcastActor
protocol Networking {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: Networking { }
