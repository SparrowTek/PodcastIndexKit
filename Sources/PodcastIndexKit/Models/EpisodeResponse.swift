/// Podcast Index API response for any endpoint that returns a single `Episode`
public struct EpisodeResponse: Codable {
	private let responseStatus: String?
	
	/// The internal PodcastIndex.org episode ID.
	public let id: String?
	
	/// Value passed to request in the feedurl parameter. If no feedurl passed, value will be null.
	public let url: String?
	
	/// Value passed to request in the guid parameter.
	public let guid: String?
	
	public let podcastGuid: String?
	
	/// Episode data
	public let episode: Episode
	
	/// Description of the response
	public let description: String
	
	/// Indicates API request status
	/// Allowed: true┃false
	public var status: Bool {
		switch responseStatus?.lowercased() {
		case "true": return true
		case "false": return false
		default: return false
		}
	}
	
	enum CodingKeys: String, CodingKey {
		case responseStatus = "status"
		case id
		case url
		case guid
		case podcastGuid
		case episode
		case description
	}
}