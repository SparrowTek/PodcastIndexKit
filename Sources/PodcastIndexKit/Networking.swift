import Foundation
import Get
import Crypto

extension JSONDecoder {
    static var podcastIndexDecoder: JSONDecoder {        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
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

var configuration: APIClient.Configuration = {
    var config = APIClient.Configuration(baseURL: URL(string: "https://api.podcastindex.org/api/1.0"), delegate: PodcastIndexAPIClientDelegate())
    config.decoder = .podcastIndexDecoder
    config.encoder = .podcastIndexEncoder
    return config
}()

var noAPIKeyConfiguration: APIClient.Configuration = {
    var config = APIClient.Configuration(baseURL: URL(string: "https://api.podcastindex.org/api/1.0"), delegate: nil)
    config.decoder = .podcastIndexDecoder
    config.encoder = .podcastIndexEncoder
    return config
}()

var appleReplacementConfiguration: APIClient.Configuration = {
    var config = APIClient.Configuration(baseURL: URL(string: "https://api.podcastindex.org/"), delegate: nil)
    
    // TODO: need to encode and decode dates in this format - "2023-05-19T09:13:38-0500"
    config.decoder = .podcastIndexDecoder
    config.encoder = .podcastIndexEncoder
    return config
}()

class PodcastIndexAPIClientDelegate: APIClientDelegate {
    func client(_ client: APIClient, willSendRequest request: inout URLRequest) async throws {
        let errorMessage = """
PODCASTINDEXKIT Error: your apiKey, secretKey, and userAgent were not set.
Please follow the intructions in the README for setting up the PodcastIndexKit framework
Hint: You must call the static setup(apiKey: String, apiSecret: String, userAgent: String) method before using the framework
"""
        guard let apiKey = PodcastIndexKit.apiKey, let apiSecret = PodcastIndexKit.apiSecret, let userAgent = PodcastIndexKit.userAgent else { fatalError(errorMessage) }
        
        // prep for crypto
        let apiHeaderTime = String(Int(Date().timeIntervalSince1970))
        let data4Hash = apiKey + apiSecret + "\(apiHeaderTime)"
        
        // ======== Hash them to get the Authorization token ========
        let inputData = Data(data4Hash.utf8)
        let hashed = Insecure.SHA1.hash(data: inputData)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        
        // set Headers
        request.addValue(apiHeaderTime, forHTTPHeaderField: "X-Auth-Date")
        request.addValue(apiKey, forHTTPHeaderField: "X-Auth-Key")
        request.addValue(hashString, forHTTPHeaderField: "Authorization")
        request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
    }

    func client(_ client: APIClient, shouldRetry task: URLSessionTask, error: Error, attempts: Int) async throws -> Bool {
        false // Disabled by default
    }

    func client(_ client: APIClient, validateResponse response: HTTPURLResponse, data: Data, task: URLSessionTask) throws {
        guard (200..<300).contains(response.statusCode) else { throw APIError.unacceptableStatusCode(response.statusCode) }
    }

    func client<T>(_ client: APIClient, makeURLForRequest request: Request<T>) throws -> URL? {
        nil // Use default handlings
    }
}
