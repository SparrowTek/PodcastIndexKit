import Foundation

@PodcastActor
public struct CategoriesService: Sendable {
    private let router: NetworkRouter<CategoriesAPI> = {
        let router = NetworkRouter<CategoriesAPI>(decoder: .podcastIndexDecoder)
        router.delegate = PodcastEnvironment.current.routerDelegate
        return router
    }()
    
    public init() {}
    
	/// Return all the possible categories supported by the index.
	/// Example: [https://api.podcastindex.org/api/1.0/categories/list?pretty](https://api.podcastindex.org/api/1.0/categories/list?pretty)
	///
	///- parameter pretty: If present, makes the output “pretty” to help with debugging.
	/// Parameter shall not have a value
	///- returns: a `CategoriesResponse` object containing an array of `Category` objects
	public func list(pretty: Bool = false) async throws -> CategoriesResponse {
        try await router.execute(.list(pretty: pretty))
	}
}

enum CategoriesAPI {
    case list(pretty: Bool)
}

extension CategoriesAPI: EndpointType {
    public var baseURL: URL {
        get async {
            let environmentURL = await PodcastEnvironment.current.indexURL
            guard let url = URL(string: environmentURL) else { fatalError("baseURL not configured.") }
            return url
        }
    }
    
    var path: String {
        switch self {
        case .list: "/categories/list"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .list: .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .list(let pretty):
            var parameters: Parameters = []
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
}
