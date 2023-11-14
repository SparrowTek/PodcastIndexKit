import Foundation
import CryptoKit

extension JSONDecoder {
    static var podcastIndexDecoder: JSONDecoder {
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

var appleReplacementBaseURL = "https://api.podcastindex.org"
var indexURL = "https://api.podcastindex.org/api/1.0"
let routerDelegate = PodcastIndexRouterDelegate()

class PodcastIndexRouterDelegate: NetworkRouterDelegate {
    func intercept(_ request: inout URLRequest) async {
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
}
