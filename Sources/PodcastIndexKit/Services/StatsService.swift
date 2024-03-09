import Foundation

public struct StatsService: Sendable {
    private let router = NetworkRouter<StatsAPI>(decoder: .podcastIndexDecoder, delegate: routerDelegate)
    
    /// Return the most recent index statistics.
    /// Hourly statistics can also be access at [https://stats.podcastindex.org/daily_counts.json](https://stats.podcastindex.org/daily_counts.json)
    ///
    ///- parameter pretty: If present, makes the output “pretty” to help with debugging.
    /// Parameter shall not have a value
    ///- returns: a `StatsResponse` object
    public func current(pretty: Bool = false) async throws -> StatsResponse {
        try await router.execute(.current(pretty: pretty))
    }
}

enum StatsAPI {
    case current(pretty: Bool)
}

extension StatsAPI: EndpointType {
    public var baseURL: URL {
        guard let url = URL(string: indexURL) else { fatalError("baseURL not configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .current: "/stats/current"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .current: .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .current(let pretty):
            var parameters: Parameters = [:]
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
}
