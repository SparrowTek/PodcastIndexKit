import Foundation

public struct AppleReplacementPodcast: Codable, Hashable, Sendable {
	/// The name of the object returned by the search request.
	/// Note: will always return "track"
	public let wrapperType: String
	
	/// The kind of content returned by the search request.
	public let kind: EntityType
	
	/// The iTunes Feed ID
	public let collectionId: Int
	
	/// The iTunes Feed ID
	public let trackId: Int
	
	/// The channel-level author element.
	/// Usually iTunes specific, but could be from another namespace if not present.
	public let artistName: String
	
	/// Name of the feed
	public let collectionName: String
	
	/// Name of the feed
	public let trackName: String
	
	/// The name of the feed.
	/// Note: Apple censors the name but PodcastIndex does not.
	public let collectionCensoredName: String
	
	/// The name of the feed.
	/// Note: Apple censors the name but PodcastIndex does not.
	public let trackCensoredName: String
	
	/// The URL for viewing the feed on the Apple website.
	public let collectionViewUrl: String
	
	/// Current feed URL
	public let feedUrl: String
	
	/// The URL for viewing the feed on the Apple website.
	public let trackViewUrl: String
	
	/// A URL for the artwork associated with the returned media type.
	/// Note: Apple returns the image sized to value in the field name but the PodcastIndex returns the original image specified in the feed.
	public let artworkUrl30: String
	
	/// A URL for the artwork associated with the returned media type.
	/// Note: Apple returns the image sized to value in the field name but the PodcastIndex returns the original image specified in the feed.
	public let artworkUrl60: String
	
	///  A URL for the artwork associated with the returned media type.
	/// Note: Apple returns the image sized to value in the field name but the PodcastIndex returns the original image specified in the feed.
	public let artworkUrl100: String
	
	/// A URL for the artwork associated with the returned media type.
	/// Note: Apple returns the image sized to value in the field name but the PodcastIndex returns the original image specified in the feed.
	public let artworkUrl600: String
	
	/// Price of content. Will always return 0.
	public let collectionPrice: Int
	
	/// Price of content. Will always return 0.
	public let trackPrice: Int
	
	/// Price of content. Will always return 0.
	public let trackRentalPrice: Int
	
	/// Price of content. Will always return 0.
	public let collectionHdPrice: Int
	
	/// Price of content. Will always return 0.
	public let trackHdPrice: Int
	
	/// Price of content. Will always return 0.
	public let trackHdRentalPrice: Int
	
	/// Date and time of request
	public let releaseDate: Date
	
	/// Indicates if the feed is marked explicit.
	/// Allowed: explicit┃cleaned
	public let collectionExplicitness: Explicitness
	
	/// Indicates if the episode is marked explicit.
	/// Allowed: explicit┃cleaned
	public let trackExplicitness: Explicitness
	
	/// Number of episodes in feed
	public let trackCount: Int
	
	/// The country the feed is from.
	public let country: String
	
	/// Currency *Price value is in.
	public let currency: String
	
	/// Indicates if the feed is explicit or clean.
	/// Allowed: Clean┃Explicit
	public let contentAdvisoryRating: Rating
	
	/// The primary genre name.
	public let primaryGenreName: String
	
	/// List of ids representing the names in the genres.
	/// Values are determined by the IDs used in the url of genres on [https://podcasts.apple.com/us/genre/podcasts/id26](https://podcasts.apple.com/us/genre/podcasts/id26)
	public let genreIds: [Int]
	
	/// List of genre names.
	public let genres: [String]
}

public enum Explicitness: String, Codable, Hashable, Sendable {
	case explicit
	case cleaned
}

public enum Rating: String, Codable, Hashable, Sendable {
	case clean
	case explicit
}

public enum EntityType: String, Codable, Hashable, Sendable {
	case podcast
}