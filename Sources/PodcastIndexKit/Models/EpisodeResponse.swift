/// Podcast Index API response for any endpoint that returns a single `Episode`
public struct EpisodeResponse: Codable, Hashable, Identifiable, Sendable {
	private let responseStatus: String?
	
	/// The internal PodcastIndex.org episode ID.
	public let id: String?
	
	/// Value passed to request in the feedurl parameter. If no feedurl passed, value will be null.
	public let url: String?
	
	/// Value passed to request in the guid parameter.
	public let guid: String?
	
	public let podcastGuid: String?
	
	/// Episode data. `nil` when Podcast Index found none.
	public let episode: Episode?
	
	/// Description of the response
	public let episodeResponseDescription: String?
	
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
		case episodeResponseDescription = "description"
	}
	
	public init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		responseStatus = try container.decodeIfPresent(String.self, forKey: .responseStatus)
		id = try container.decodeIfPresent(String.self, forKey: .id)
		url = try container.decodeIfPresent(String.self, forKey: .url)
		guid = try container.decodeIfPresent(String.self, forKey: .guid)
		podcastGuid = try container.decodeIfPresent(String.self, forKey: .podcastGuid)
		episode = try container.decodeIfFound(Episode.self, forKey: .episode)
		episodeResponseDescription = try container.decodeIfPresent(String.self, forKey: .episodeResponseDescription)
	}
}
