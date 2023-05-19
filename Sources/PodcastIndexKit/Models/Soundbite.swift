import Foundation

public struct Soundbite: Codable {
	/// The time where the soundbite begins in the item specified by the enclosureUrl
	public let startTime: Date
	
	/// The length to play the item specified by the enclosureUrl
	public let duration: Int
	
	/// Name of the soundbite
	public let title: String
	
	/// URL/link to the episode file
	public let enclosureUrl: String?
	
	/// The internal PodcastIndex.org episode ID.	
	public let episodeId: Int?
	
	/// Name of the episode
	public let episodeTitle: String?
	
	/// Name of the feed
	public let feedTitle: String?
	
	/// Current feed URL
	public let feedUrl: String?
	
	/// The internal PodcastIndex.org Feed ID.
	public let feedId: Int?
}
