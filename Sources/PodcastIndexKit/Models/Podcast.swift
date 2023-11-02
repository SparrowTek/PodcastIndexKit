import Foundation

/// All of the information about a Podcast
public struct Podcast: Codable, Hashable, Sendable {
    
    /// The internal PodcastIndex.org Feed ID.
    public let id: Int?
    
    /// Name of the feed
    public let title: String?
    
    /// Current feed URL
    public let url: String?
    
    /// The URL of the feed, before it changed to the current url value.
    public let originalUrl: String?
    
    /// The channel-level link in the feed
    public let link: String?
    
    /// The channel-level description
    /// Uses the longer of the possible fields in the feed: <description>, <itunes:summary> and <content:encoded>
    public let podcastDescription: String?
    
    /// The channel-level author element.
    /// Usually iTunes specific, but could be from another namespace if not present.
    public let author: String?
    
    /// The channel-level owner:name element.
    /// Usually iTunes specific, but could be from another namespace if not present.
    public let ownerName: String?
    
    /// The channel-level image element.
    public let image: String?
    
    /// The seemingly best artwork we can find for the feed. Might be the same as image in most instances.
    public let artwork: String?
    
    /// The channel-level pubDate for the feed, if it’s sane. If not, this is a heuristic value, arrived at by analyzing other parts of the feed, like item-level pubDates.
    public let lastUpdateTime: Date?
    
    /// The last time we attempted to pull this feed from its url.
    public let lastCrawlTime: Date?
    
    /// The last time we tried to parse the downloaded feed content.
    public let lastParseTime: Date?
    
    /// Timestamp of the last time we got a "good", meaning non-4xx/non-5xx, status code when pulling this feed from its url.
    public let lastGoodHttpStatusTime: Date?
    
    /// The last http status code we got when pulling this feed from its url.
    /// You will see some made up status codes sometimes. These are what we use to track state within the feed puller. These all start with 9xx.
    public let lastHttpStatus: Int?
    
    /// The Content-Type header from the last time we pulled this feed from its url.
    public let contentType: String?
    
    /// The iTunes ID of this feed if there is one, and we know what it is.
    public let itunesId: Int?
    
    /// The channel-level generator element if there is one.
    public let generator: String?
    
    /// The channel-level language specification of the feed. Languages accord with the [RSS Language Spec](https://www.rssboard.org/rss-language-codes).
    public let language: String?
    
    /// Type of source feed where:
    /// - 0: RSS
    /// - 1: Atom
    /// Allowed: 0┃1
    public let type: PodcastType?
    
    /// At some point, we give up trying to process a feed and mark it as dead. This is usually after 1000 errors without a successful pull/parse cycle. Once the feed is marked dead, we only check it once per month.
    public let dead: Int?
    
    /// The number of errors we’ve encountered trying to pull a copy of the feed. Errors are things like a 500 or 404 response, a server timeout, bad encoding, etc.
    public let crawlErrors: Int?
    
    /// The number of errors we’ve encountered trying to parse the feed content. Errors here are things like not well-formed xml, bad character encoding, etc.
    /// We fix many of these types of issues on the fly when parsing. We only increment the errors count when we can’t fix it.
    public let parseErrors: Int?
    
    /// An array of categories, where the index is the Category ID and the value is the Category Name.
    /// All Category numbers and names are returned by the categories/list endpoint.
    public let categories: [String : String]?
    
    /// Tell other podcast platforms whether they are allowed to import this feed. A value of 1 means that any attempt to import this feed into a new platform should be rejected. Contains the value of the feed's channel-level podcast:locked tag where:
    /// - 0: 'no'
    /// - 1: 'yes'
    /// Allowed: 0┃1
    public let locked: PodcastLocked?
    
    /// The GUID from the podcast:guid tag in the feed. This value is a unique, global identifier for the podcast.
    /// See the namespace spec for [guid](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#guid) for details.
    public let podcastGuid: String?
    
    /// Number of episodes for this feed known to the index.
    public let episodeCount: Int?
    
    /// A CRC32 hash of the image URL with the protocol (http://, https://) removed.
    public let imageUrlHash: Double?
    
    /// The time the most recent episode in the feed was published.
    /// Note: some endpoints use newestItemPubdate while others use newestItemPublishTime. They return the same information. See [https://github.com/Podcastindex-org/api/issues/3](https://github.com/Podcastindex-org/api/issues/3) to track when the property name is updated.
    public let newestItemPubdate: Date?
    
    /// Is feed marked as explicit
    public let explicit: Bool?
    
    /// The type as specified by the itunes:type in the feed XML.
    public let itunesType: String?
    
    /// The md5 hash of the following feed items in hex format.
    /// - title
    /// - link
    /// - feedLanguage
    /// - generator
    /// - author
    /// - ownerName
    /// - ownerEmail (note: not exposed via the API)
    /// Pseudo-code:
    /// chash = md5(title+link+feedLanguage+generator+author+ownerName+ownerEmail)
    public let chash: String?
    
    /// Information for supporting the podcast via one of the "Value for Value" methods.
    /// Examples:
    /// - lightning value type: [https://api.podcastindex.org/api/1.0/podcasts/byfeedid?id=169991&pretty](https://api.podcastindex.org/api/1.0/podcasts/byfeedid?id=169991&pretty)
    /// - webmonetization value type: [https://api.podcastindex.org/api/1.0/podcasts/byfeedid?id=779873&pretty](https://api.podcastindex.org/api/1.0/podcasts/byfeedid?id=779873&pretty)
    public let value: PodcastValue?
    
    /// Information for donation/funding the podcast.
    /// See the [podcast namespace spec](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#funding) for more information.
    public let funding: PodcastFunding?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case url
        case originalUrl
        case link
        case podcastDescription = "description"
        case author
        case ownerName
        case image
        case artwork
        case lastUpdateTime
        case lastCrawlTime
        case lastParseTime
        case lastGoodHttpStatusTime
        case lastHttpStatus
        case contentType
        case itunesId
        case generator
        case language
        case type
        case dead
        case crawlErrors
        case parseErrors
        case categories
        case locked
        case podcastGuid
        case episodeCount
        case imageUrlHash
        case newestItemPubdate
        case explicit
        case itunesType
        case chash
        case value
        case funding
    }
}

public enum PodcastType: Int, Codable, Hashable, Sendable {
    case rss = 0
    case atom = 1
}

public enum PodcastLocked: Int, Codable, Hashable, Sendable {
    case no = 0
    case yes = 1
}

public struct PodcastValue: Codable, Hashable, Sendable {
    public let model: PodcastValueModel?
    public let destinations: [PodcastValueDestination]?
}

public struct PodcastValueModel: Codable, Hashable, Sendable {
    public let type: String?
    public let method: String?
    public let suggested: String?
}

public struct PodcastValueDestination: Codable, Hashable, Sendable {
    public let name: String?
    public let type: String?
    public let address: String?
    public let split: Int?
    public let customKey: String?
    public let customValue: String?
    public let fee: Bool?
}

public struct PodcastFunding: Codable, Hashable, Sendable {
    public let url: String?
    public let message: String?
}
