import Get

public struct AddService {
	private let apiClient = APIClient(configuration: noAPIKeyConfiguration)
	private let basePath = "/add"
	
	/// Notify the index that a feed has changed
	///
	///- parameter id: The PodcastIndex Feed ID
	/// The id or the url is required.	
	///- parameter url: The Podcast Feed URL
	/// The id or the url is required.
	///- parameter pretty: If present, makes the output “pretty” to help with debugging.
	/// Parameter shall not have a value
	///- returns: a `PubNotifyResponse` object
	// public func pubNotify(id: String? = nil, url: String? = nil, pretty: Bool = false) async throws -> PubNotifyResponse {
	// 	var query: [(String, String?)]?
	// 	append(id, toQuery: &query, withKey: "id")
	// 	append(url, toQuery: &query, withKey: "url")
	// 	appendNil(toQuery: &query, withKey: "pretty", forBool: pretty)
	// 	
	// 	return try await apiClient.send(Request(path: "\(basePath)/pubnotify", query: query)).value
	// }
}
