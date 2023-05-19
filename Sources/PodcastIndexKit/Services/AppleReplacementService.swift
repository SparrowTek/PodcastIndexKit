import Get

public struct AppleReplacementService {
	private let apiClient = APIClient(configuration: appleReplacementConfiguration)
	
	/// Replaces the Apple search API but returns data from the Podcast Index database.
	/// Note: No API key needed for this endpoint.
	///
	///- parameter term: The term to search for
	///- parameter pretty: If present, makes the output “pretty” to help with debugging.
	/// Parameter shall not have a value
	///- returns: a `AppleReplacementSearchResponse` object which contains an array of `AppleReplacementPodcast` objects
	public func search(byTerm term: String, pretty: Bool = false) async throws -> AppleReplacementSearchResponse {
		var query: [(String, String?)]? = [("term", term)]
		appendNil(toQuery: &query, withKey: "pretty", forBool: pretty)
		
		return try await apiClient.send(Request(path: "/search", query: query)).value
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
		var query: [(String, String?)]? = [("id", id)]
		append(entity?.rawValue, toQuery: &query, withKey: "entity")
		appendNil(toQuery: &query, withKey: "pretty", forBool: pretty)
		
		return try await apiClient.send(Request(path: "/lookup", query: query)).value
	}
}
