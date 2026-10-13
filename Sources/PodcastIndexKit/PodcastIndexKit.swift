import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Errors raised by PodcastIndexKit before a request reaches the network.
public enum PodcastIndexError: Error, Sendable, Equatable {
    /// ``PodcastIndexKit/setup(apiKey:apiSecret:userAgent:networking:)`` was never called.
    case notConfigured
    /// The configured base URL could not be turned into a `URL`.
    case invalidBaseURL(String)
}

public enum PodcastIndexKit {
    /// Configures the API credentials every service uses.
    ///
    /// Call this once before making requests. The key and secret must stay on a
    /// server you control: Podcast Index's terms forbid shipping them inside a
    /// client application, where anyone can extract them from the binary.
    ///
    /// - Parameters:
    ///   - apiKey: The Podcast Index API key.
    ///   - apiSecret: The matching API secret.
    ///   - userAgent: A User-Agent naming your application, which the terms require on every request.
    ///   - networking: An optional transport. Defaults to a `URLSession`. Inject one to test
    ///     without the network or to route requests through another HTTP client.
    static public func setup(apiKey: String, apiSecret: String, userAgent: String, networking: (any PodcastIndexNetworking)? = nil) async {
        await PodcastEnvironment.current.setup(apiKey: apiKey, apiSecret: apiSecret, userAgent: userAgent, networking: networking)
    }
}
