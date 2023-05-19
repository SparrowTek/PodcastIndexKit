import Get

public struct ValueService {
	private let apiClient = APIClient(configuration: configuration)
	private let basePath = "/value"
	
	/// This call returns the information for supporting the podcast via one of the "Value for Value" methods from the PodcastIndex ID.
	/// Additionally, the value block data can be accessed using static JSON files (updated every 15 minutes).
	///
	///- parameter id: (Required) The PodcastIndex Feed ID to search for.
	///- parameter pretty: If present, makes the output “pretty” to help with debugging.
	///- parameter shall not have a value
	///- returns: a `ValueResponse` object
	public func value(byFeedID id: String, pretty: Bool = false) async throws -> ValueResponse {
		var query: [(String, String?)]? = [("id", id)]
		appendNil(toQuery: &query, withKey: "pretty", forBool: pretty)
				
		return try await apiClient.send(Request(path: "\(basePath)/byfeedid", query: query)).value	
	}
	
	/// This call returns the information for supporting the podcast via one of the "Value for Value" methods from feed URL.
	/// Additionally, the value block data can be accessed using static JSON files (updated every 15 minutes).
	/// 
	///- parameter url: (Required) Podcast feed URL
	///- parameter pretty: If present, makes the output “pretty” to help with debugging.
	/// Parameter shall not have a value
	///- returns: a `ValueResponse` object
	public func value(byFeedURL url: String, pretty: Bool = false) async throws -> ValueResponse {
		var query: [(String, String?)]? = [("url", url)]
		appendNil(toQuery: &query, withKey: "pretty", forBool: pretty)
				
		return try await apiClient.send(Request(path: "\(basePath)/byfeedurl", query: query)).value	
	}
}