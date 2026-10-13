import Foundation

/// /// All of the information about an Episode
public struct Episode: Codable, Hashable, Identifiable, Sendable {
    /// The internal PodcastIndex.org episode ID.
    public let id: Int?
    
    /// Name of the feed
    public let title: String?
    
    /// The channel-level link in the feed
    public let link: String?
    
    /// The item-level description of the episode.
    /// Uses the longer of the possible fields in the feed: <description>, <itunes:summary> and <content:encoded>
    public let episodeDescription: String?
    
    /// The unique identifier for the episode
    public let guid: String?
    
    /// The date and time the episode was published
    public let datePublished: Date?
    
    /// The date and time the episode was published formatted as a human readable string.
    /// Note: uses the PodcastIndex server local time to do conversion.
    public let datePublishedPretty: String?
    
    /// The time this episode was found in the feed
    public let dateCrawled: Date?
    
    /// URL/link to the episode file
    public let enclosureUrl: String?
    
    /// The Content-Type for the item specified by the enclosureUrl
    public let enclosureType: String?
    
    /// The length of the item specified by the enclosureUrl in bytes
    public let enclosureLength: Int?
    
    /// Link TODO
    public let contentLink: String?
    
    /// The estimated length of the item specified by the enclosureUrl in seconds
    public let duration: Int?
    
    /// Is feed or episode marked as explicit
    /// 0: not marked explicit
    /// 1: marked explicit
    /// Allowed: 0┃1
    public let explicit: EpisodeExplicitStatus?
    
    /// Episode number
    public let episode: Int?
    
    /// The type of episode
    /// Allowed: full┃trailer┃bonus
    public let episodeType: EpisodeType?
    
    /// Season number
    public let season: Int?
    
    /// The item-level image for the episode
    public let image: String?
    
    /// The iTunes ID of this feed if there is one, and we know what it is.
    public let feedItunesId: Int?
    
    /// The channel-level image element.
    public let feedImage: String?
    
    /// The internal PodcastIndex.org Feed ID.
    public let feedId: Int?

    /// The podcast:guid of the feed this episode belongs to.
    public let podcastGuid: String?

    /// Current feed URL of the podcast this episode belongs to.
    public let feedUrl: String?
    
    /// The channel-level language specification of the feed. Languages accord with the RSS Language Spec.
    public let feedLanguage: String?
    
    /// At some point, we give up trying to process a feed and mark it as dead. This is usually after 1000 errors without a successful pull/parse cycle. Once the feed is marked dead, we only check it once per month.
    public let feedDead: Int?
    
    /// Name of the feed
    public let feedTitle: String?
    
    /// The internal PodcastIndex.org Feed ID this feed duplicates
    public let feedDuplicateOf: Int?
    
    /// Link to the JSON file containing the episode chapters
    public let chaptersUrl: String?
    
    /// Link to the file containing the episode transcript
    /// Note: in most use cases, the transcripts value should be used instead
    public let transcriptUrl: String?
    
    /// A CRC32 hash of the feedImage URL with the protocol (http://, https://) removed.
    public let feedImageUrlHash: Int?
    
    /// A CRC32 hash of the image URL with the protocol (http://, https://) removed.
    public let imageUrlHash: Int?
    
    /// List of transcripts for the episode.
    /// ⮕ [ This tag is used to link to a transcript or closed captions file. Multiple tags can be present for multiple transcript formats. Detailed file format information and example files are [here](https://github.com/Podcastindex-org/podcast-namespace/blob/main/transcripts/transcripts.md). ]
    public let transcripts: [Transcript]?
    
    /// List of people with an interest in this episode.
    /// See the [podcast namespace spec](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#person) for more information.
    public let persons: [Person]?
    
    /// List the social interact data found in the podcast feed.
    /// See the [podcast namespace spec](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#social-interact) for more information.
    public let socialInteract: [SocialInteractData]?
    
    /// Information for supporting the podcast via one of the "Value for Value" methods.
    /// Examples:
    /// lightning value type: [https://api.podcastindex.org/api/1.0/podcasts/byfeedid?id=169991&pretty](https://api.podcastindex.org/api/1.0/podcasts/byfeedid?id=169991&pretty)
    /// webmonetization value type: [https://api.podcastindex.org/api/1.0/podcasts/byfeedid?id=779873&pretty](https://api.podcastindex.org/api/1.0/podcasts/byfeedid?id=779873&pretty)
    public let value: Value?
    
    /// Soundbite for episode
    public let soundbite: Soundbite?
    
    /// Soundbites for episode
    /// ⮕ [ Soundbite for episode ]
    public let soundbites: [Soundbite]?
    
    /// Transcript information for the episode.
    /// See the [podcast namespace spec](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#transcript) for more information.
    public let transcript: Transcript?
    
    // MARK: Live streams
    /// The time the livestream starts
    public let startTime: Int?
    
    /// The time the livestream ends
    public let endTime: Int?
    
    /// Status of the livestream
    /// Allowed: ended┃live
    public let status: LivestreamStatus?

    public init(
        id: Int? = nil,
        title: String? = nil,
        link: String? = nil,
        episodeDescription: String? = nil,
        guid: String? = nil,
        datePublished: Date? = nil,
        datePublishedPretty: String? = nil,
        dateCrawled: Date? = nil,
        enclosureUrl: String? = nil,
        enclosureType: String? = nil,
        enclosureLength: Int? = nil,
        contentLink: String? = nil,
        duration: Int? = nil,
        explicit: EpisodeExplicitStatus? = nil,
        episode: Int? = nil,
        episodeType: EpisodeType? = nil,
        season: Int? = nil,
        image: String? = nil,
        feedItunesId: Int? = nil,
        feedImage: String? = nil,
        feedId: Int? = nil,
        podcastGuid: String? = nil,
        feedUrl: String? = nil,
        feedLanguage: String? = nil,
        feedDead: Int? = nil,
        feedTitle: String? = nil,
        feedDuplicateOf: Int? = nil,
        chaptersUrl: String? = nil,
        transcriptUrl: String? = nil,
        feedImageUrlHash: Int? = nil,
        imageUrlHash: Int? = nil,
        transcripts: [Transcript]? = nil,
        persons: [Person]? = nil,
        socialInteract: [SocialInteractData]? = nil,
        value: Value? = nil,
        soundbite: Soundbite? = nil,
        soundbites: [Soundbite]? = nil,
        transcript: Transcript? = nil,
        startTime: Int? = nil,
        endTime: Int? = nil,
        status: LivestreamStatus? = nil
    ) {
        self.id = id
        self.title = title
        self.link = link
        self.episodeDescription = episodeDescription
        self.guid = guid
        self.datePublished = datePublished
        self.datePublishedPretty = datePublishedPretty
        self.dateCrawled = dateCrawled
        self.enclosureUrl = enclosureUrl
        self.enclosureType = enclosureType
        self.enclosureLength = enclosureLength
        self.contentLink = contentLink
        self.duration = duration
        self.explicit = explicit
        self.episode = episode
        self.episodeType = episodeType
        self.season = season
        self.image = image
        self.feedItunesId = feedItunesId
        self.feedImage = feedImage
        self.feedId = feedId
        self.podcastGuid = podcastGuid
        self.feedUrl = feedUrl
        self.feedLanguage = feedLanguage
        self.feedDead = feedDead
        self.feedTitle = feedTitle
        self.feedDuplicateOf = feedDuplicateOf
        self.chaptersUrl = chaptersUrl
        self.transcriptUrl = transcriptUrl
        self.feedImageUrlHash = feedImageUrlHash
        self.imageUrlHash = imageUrlHash
        self.transcripts = transcripts
        self.persons = persons
        self.socialInteract = socialInteract
        self.value = value
        self.soundbite = soundbite
        self.soundbites = soundbites
        self.transcript = transcript
        self.startTime = startTime
        self.endTime = endTime
        self.status = status
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case link
        case episodeDescription = "description"
        case guid
        case datePublished
        case datePublishedPretty
        case dateCrawled
        case enclosureUrl
        case enclosureType
        case enclosureLength
        case contentLink
        case duration
        case explicit
        case episode
        case episodeType
        case season
        case image
        case feedItunesId
        case feedImage
        case feedId
        case podcastGuid
        case feedUrl
        case feedLanguage
        case feedDead
        case feedTitle
        case feedDuplicateOf
        case chaptersUrl
        case transcriptUrl
        case feedImageUrlHash
        case imageUrlHash
        case transcripts
        case persons
        case socialInteract
        case value
        case soundbite
        case soundbites
        case transcript
        case startTime
        case endTime
        case status
    }
}

public enum LivestreamStatus: String, Codable, Hashable, Sendable {
    case ended
    case live
}

public enum EpisodeExplicitStatus: Int, Codable, Hashable, Sendable {
    case notExplicit = 0
    case explicit = 1
}

public enum EpisodeType: String, Codable, Hashable, Sendable {
    case full
    case trailer
    case bonus
}

public struct SocialInteractData: Codable, Hashable, Sendable {
    /// The uri/url of the root post comment
    public let url: String?
    
    /// The protocol in use for interacting with the comment root post.
    /// For the most up-to-date list of options, see [https://github.com/Podcastindex-org/podcast-namespace/blob/main/socialprotocols.txt](https://github.com/Podcastindex-org/podcast-namespace/blob/main/socialprotocols.txt)
    /// Allowed: disabled┃activitypub┃twitter┃lightning
    public let `protocol`: SocialIteractProtocol?
    
    public enum SocialIteractProtocol: String, Codable, Hashable, Sendable {
        case disabled
        case activitypub
        case twitter
        case lightning
    }
    
    /// The account id (on the commenting platform) of the account that created this root post.
    public let accountId: String?
    
    /// The public url (on the commenting platform) of the account that created this root post.
    public let accountUrl: String?
    
    /// When multiple socialInteract tags are present, this integer gives order of priority. A lower number means higher priority.
    public let priority: Int?
}

public struct Person: Codable, Hashable, Sendable {
    
    /// The internal PodcastIndex.org person ID.
    public let id: Int?
    
    /// The name of the person.
    /// See the [podcast namespace spec](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#person) for more information.
    public let name: String?
    
    /// Used to identify what role the person serves on the show or episode.
    /// Value should be an official role within the Podcast Taxonomy Project [list](https://github.com/Podcastindex-org/podcast-namespace/blob/main/taxonomy.json).
    /// See the [podcast namespace spec](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#person) for more information.
    public let role: String?
    
    /// The group the person's role is in.
    /// Value should be an official group within the Podcast Taxonomy Project [list](https://github.com/Podcastindex-org/podcast-namespace/blob/main/taxonomy.json).
    /// See the [podcast namespace spec](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#person) for more information.
    public let group: String?
    
    /// The url to a relevant resource of information about the person, such as a homepage or third-party profile platform.
    /// See the [podcast namespace spec](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#person) for more information.
    public let href: String?
    
    /// URL to a picture or avatar of the person.
    /// See the [podcast namespace spec](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#person) for more information.
    public let img: String?
}
