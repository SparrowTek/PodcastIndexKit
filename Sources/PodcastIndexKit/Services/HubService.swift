import Foundation

public struct HubService {
    private let router = NetworkRouter<HubAPI>(decoder: .podcastIndexDecoder)
    
    /// Notify the index that a feed has changed
    ///
    ///- parameter id: The PodcastIndex Feed ID
    /// The id or the url is required.
    ///- parameter url: The Podcast Feed URL
    /// The id or the url is required.
    ///- parameter pretty: If present, makes the output “pretty” to help with debugging.
    /// Parameter shall not have a value
    ///- returns: a `PubNotifyResponse` object
    public func pubNotify(id: String? = nil, url: String? = nil, pretty: Bool = false) async throws -> PubNotifyResponse {
        try await router.execute(.pubNotify(id: id, url: url, pretty: pretty))
    }
}

enum HubAPI {
    case pubNotify(id: String?, url: String?, pretty: Bool)
}

extension HubAPI: EndpointType {
    public var baseURL: URL {
        guard let url = URL(string: indexURL) else { fatalError("baseURL not configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .pubNotify: "/hub/pubnotify"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .pubNotify: .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .pubNotify(let id, let url, let pretty):
            var parameters: Parameters = [:]
            append(id, toParameters: &parameters, withKey: "id")
            append(url, toParameters: &parameters, withKey: "url")
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
}

