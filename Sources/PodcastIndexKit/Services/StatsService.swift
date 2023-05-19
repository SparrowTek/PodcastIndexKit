import Get

public struct StatsService {
	private let apiClient = APIClient(configuration: configuration)
	private let basePath = "/stats"
	
	/// Return the most recent index statistics.
	/// Hourly statistics can also be access at [https://stats.podcastindex.org/daily_counts.json](https://stats.podcastindex.org/daily_counts.json)
	///
	///- parameter pretty: If present, makes the output “pretty” to help with debugging.
	/// Parameter shall not have a value
	///- returns: a `StatsResponse` object
	public func current(pretty: Bool = false) async throws -> StatsResponse {
		var query: [(String, String?)]?
		appendNil(toQuery: &query, withKey: "pretty", forBool: pretty)
				
		return try await apiClient.send(Request(path: "\(basePath)/current", query: query)).value	
	}
}
