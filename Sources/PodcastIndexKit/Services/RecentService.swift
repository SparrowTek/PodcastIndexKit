import Foundation
import Get

public struct RecentService {
	private let apiClient = APIClient(configuration: configuration)
	private let basePath = "/recent"
	
	/// This call returns the most recent max number of episodes globally across the whole index, in reverse chronological order.
	///
	///- parameter max: Maximum number of results to return.
	///- parameter excludeString: Any item containing this string will be discarded from the result set.
	/// This may, in certain cases, reduce your set size below your max value.
	/// Matches against the title and URL properties.
	///- parameter before: If you pass a PodcastIndex Episode ID, you will get recent episodes before that ID, allowing you to walk back through the episode history sequentially.
	///- parameter fulltext: If present, return the full text value of any text fields (ex: description). If not provided, field value is truncated to 100 words.
	///- parameter shall not have a value
	///- parameter pretty: If present, makes the output “pretty” to help with debugging.
	/// Parameter shall not have a value
	/// - returns: an `EpisodeArrayResult` object containing an array of `Episode`s.
	public func recentEpisodes(max: Int? = nil, excludeString: String? = nil, before: Date? = nil, fulltext: Bool = false, pretty: Bool = false) async throws -> EpisodeArrayResult {
		var query: [(String, String?)]?
		
		append(max, toQuery: &query, withKey: "max")
		append(excludeString, toQuery: &query, withKey: "excludeString")
		append(before, toQuery: &query, withKey: "before")
		appendNil(toQuery: &query, withKey: "fulltext", forBool: fulltext)
		appendNil(toQuery: &query, withKey: "pretty", forBool: pretty)
		return try await apiClient.send(Request(path: "\(basePath)/episodes", query: query)).value
	}
}