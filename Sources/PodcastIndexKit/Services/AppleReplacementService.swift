import Foundation

public struct AppleReplacementService {
    private let router = NetworkRouter<AppleReplacementAPI>(decoder: .podcastIndexDecoder)
	
	/// Replaces the Apple search API but returns data from the Podcast Index database.
	/// Note: No API key needed for this endpoint.
	///
	///- parameter term: The term to search for
	///- parameter pretty: If present, makes the output “pretty” to help with debugging.
	/// Parameter shall not have a value
	///- returns: a `AppleReplacementSearchResponse` object which contains an array of `AppleReplacementPodcast` objects
	public func search(byTerm term: String, pretty: Bool = false) async throws -> AppleReplacementSearchResponse {
        try await router.execute(.search(term: term, pretty: pretty))
	}
	
	/// Replaces the Apple podcast lookup API but returns data from the Podcast Index database.
	/// Note: No API key needed for this endpoint.
	///
	///- parameter id: The iTunes Feed ID to search for
	///- parameter entity: The iTunes entity type to look in
	//- parameter pretty: If present, makes the output “pretty” to help with debugging.
	/// Parameter shall not have a value
	///- returns: a `AppleReplacementSearchResponse` object which contains an array of `AppleReplacementPodcast` objects
	public func lookup(id: String, entity: EntityType? = nil, pretty: Bool = false) async throws -> AppleReplacementSearchResponse {
        try await router.execute(.lookup(id: id, entity: entity?.rawValue, pretty: pretty))
	}
}

enum AppleReplacementAPI {
    case search(term: String, pretty: Bool)
    case lookup(id: String, entity: String?, pretty: Bool)
}

extension AppleReplacementAPI: EndpointType {
    public var baseURL: URL {
        guard let url = URL(string: appleReplacementBaseURL) else { fatalError("baseURL not configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .search: "/search"
        case .lookup: "/lookup"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .search, .lookup: .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .search(let term, let pretty):
            var parameters: Parameters = ["term" : term]
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        case .lookup(let id, let entity, let pretty):
            var parameters: Parameters = ["id" : id]
            append(entity, toParameters: &parameters, withKey: "entity")
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
}
