import Foundation

public struct ValueService {
    private let router = NetworkRouter<ValueAPI>(decoder: .podcastIndexDecoder, delegate: routerDelegate)
    
    /// This call returns the information for supporting the podcast via one of the "Value for Value" methods from the PodcastIndex ID.
    /// Additionally, the value block data can be accessed using static JSON files (updated every 15 minutes).
    ///
    ///- parameter id: (Required) The PodcastIndex Feed ID to search for.
    ///- parameter pretty: If present, makes the output “pretty” to help with debugging.
    ///- parameter shall not have a value
    ///- returns: a `ValueResponse` object
    public func value(byFeedID id: String, pretty: Bool = false) async throws -> ValueResponse {
        try await router.execute(.byFeedID(id: id, pretty: pretty))
    }
    
    /// This call returns the information for supporting the podcast via one of the "Value for Value" methods from feed URL.
    /// Additionally, the value block data can be accessed using static JSON files (updated every 15 minutes).
    ///
    ///- parameter url: (Required) Podcast feed URL
    ///- parameter pretty: If present, makes the output “pretty” to help with debugging.
    /// Parameter shall not have a value
    ///- returns: a `ValueResponse` object
    public func value(byFeedURL url: String, pretty: Bool = false) async throws -> ValueResponse {
        try await router.execute(.byFeedURL(url: url, pretty: pretty))
    }
}

enum ValueAPI {
    case byFeedID(id: String, pretty: Bool)
    case byFeedURL(url: String, pretty: Bool)
}

extension ValueAPI: EndpointType {
    public var baseURL: URL {
        guard let url = URL(string: indexURL) else { fatalError("baseURL not configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .byFeedID: "/value/byfeedid"
        case .byFeedURL: "/value/byfeedurl"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .byFeedID, .byFeedURL: .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .byFeedID(let id, let pretty):
            var parameters: Parameters = ["id" : id]
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        case .byFeedURL(let url, let pretty):
            var parameters: Parameters = ["url" : url]
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
}
