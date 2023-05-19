import Foundation

public struct DataResponse: Codable {
	private let resultStatus: String?
	
	/// Number of items in the feeds returned in request
	public let feedCount: Int?
	
	/// Number of items in the items returned in request
	public let itemCount: Int?
	
	/// Value of max parameter passed to request.
	public let max: Int?
	
	/// Value of since parameter passed to request.
	public let since: Date?
	
	/// Description of the response
	public let description: String
	
	/// Value to pass as since parameter to get next batch of data
	public let nextSince: Int?
	
	/// Object containing the recent data
	public let data: PodcastIndexData?
	
	/// Indicates API request status
	/// Allowed: true┃false
	public var status: Bool {
		switch resultStatus?.lowercased() {
		case "true": return true
		case "false": return false
		default: return false
		}
	}
	
	enum CodingKeys: String, CodingKey {
		case resultStatus = "status"
		case feedCount
		case itemCount
		case max
		case since
		case description
		case nextSince
		case data
	}
}

public struct PodcastIndexData: Codable {
	/// Position in data
	public let position: Int
	
	/// List of recent feed data
	public let feeds: [PodcastData]
	
	/// List of recent episode item data
	public let items: [EpisodeData]
}

public struct PodcastData: Codable {
	/// The internal PodcastIndex.org Feed ID.
	public let feedId: Int
	
	/// Current feed URL
	public let feedUrl: String
	
	/// Name of the feed
	public let feedTitle: String
	
	/// The channel-level description
	/// Uses the longer of the possible fields in the feed: <description>, <itunes:summary> and <content:encoded>
	public let feedDescription: String
	
	/// The channel-level image element.
	public let feedImage: String
	
	/// The channel-level language specification of the feed. Languages accord with the [RSS Language Spec](https://www.rssboard.org/rss-language-codes).
	public let feedLanguage: String
	
	/// The iTunes ID of this feed if there is one, and we know what it is.
	public let feedItunesId: Int
}

public struct EpisodeData: Codable {
	/// The internal PodcastIndex.org episode ID.
	public let episodeId: Int
	
	/// Name of the feed
	public let episodeTitle: String
	
	/// The item-level description of the episode.
	/// Uses the longer of the possible fields in the feed: <description>, <itunes:summary> and <content:encoded>
	public let episodeDescription: String
	
	/// The item-level image for the episode
	public let episodeImage: String
	
	/// The date and time the episode was published
	public let episodeTimestamp: Date
	
	/// The time the episode was added to the index
	public let episodeAdded: Date
	
	/// URL/link to the episode file
	public let episodeEnclosureUrl: String?
	
	/// The length of the item specified by the enclosureUrl in bytes
	public let episodeEnclosureLength: Int?
	
	/// The Content-Type for the item specified by the enclosureUrl
	public let episodeEnclosureType: String
	
	/// The estimated length of the item specified by the enclosureUrl in seconds
	public let episodeDuration: Int
	
	/// The type of episode
	public let episodeType: EpisodeType
	
	/// The internal PodcastIndex.org Feed ID.
	public let feedId: Int
}