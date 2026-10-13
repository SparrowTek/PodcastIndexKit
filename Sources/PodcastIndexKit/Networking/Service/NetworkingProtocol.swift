@preconcurrency import Foundation
#if canImport(FoundationNetworking)
@preconcurrency import FoundationNetworking
#endif

/// The transport PodcastIndexKit sends requests through. `URLSession` conforms;
/// supply your own implementation to stub responses in tests or to use a
/// different HTTP client on the server.
@PodcastActor
public protocol PodcastIndexNetworking: Sendable {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: PodcastIndexNetworking { }
