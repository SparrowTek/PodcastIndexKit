import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
#if canImport(CryptoKit)
import CryptoKit
#else
import Crypto
#endif

extension JSONDecoder {
    /// The decoder every Podcast Index response is parsed with: snake_case keys
    /// become camelCase and dates arrive as Unix timestamps in seconds.
    public static var podcastIndexDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let timestampInSeconds = try container.decode(Int.self)
            return Date(timeIntervalSince1970: TimeInterval(timestampInSeconds))
        }
        
        return decoder
    }
}

extension JSONEncoder {
    static var podcastIndexEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        return encoder
    }
}

@PodcastActor
class PodcastIndexRouterDelegate: NetworkRouterDelegate {
    func shouldRetry(error: any Error, attempts: Int) async throws -> Bool {
        false
    }
    
    func intercept(_ request: inout URLRequest) async throws {
        guard let apiKey = PodcastEnvironment.current.apiKey,
              let apiSecret = PodcastEnvironment.current.apiSecret,
              let userAgent = PodcastEnvironment.current.userAgent else {
            throw PodcastIndexError.notConfigured
        }
        
        let apiHeaderTime = String(Int(Date().timeIntervalSince1970))
        Self.sign(&request, apiKey: apiKey, apiSecret: apiSecret, userAgent: userAgent, apiHeaderTime: apiHeaderTime)
    }

    /// Adds the Podcast Index authentication headers: the request time, the key,
    /// and `sha1(key + secret + time)` as the Authorization value.
    nonisolated static func sign(_ request: inout URLRequest, apiKey: String, apiSecret: String, userAgent: String, apiHeaderTime: String) {
        let data4Hash = apiKey + apiSecret + apiHeaderTime
        let hashed = Insecure.SHA1.hash(data: Data(data4Hash.utf8))
        let hashString = hashed.map { String(format: "%02x", $0) }.joined()
        
        request.setValue(apiHeaderTime, forHTTPHeaderField: "X-Auth-Date")
        request.setValue(apiKey, forHTTPHeaderField: "X-Auth-Key")
        request.setValue(hashString, forHTTPHeaderField: "Authorization")
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
    }
}
