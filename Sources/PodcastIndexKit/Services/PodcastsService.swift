import Foundation

public struct PodcastsService {
    private let router = NetworkRouter<PodcastsAPI>(decoder: .podcastIndexDecoder, delegate: routerDelegate)
    
    /// This call returns everything we know about the feed from the PodcastIndex Feed ID
    ///
    /// - parameter id: (Required) The PodcastIndex Feed ID
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging. Parameter shall not have a value
    /// - returns: a `Podcast` object containing information about the feed.
    public func podcast(byFeedId id: Int, pretty: Bool = false) async throws -> PodcastResponse {
        try await router.execute(.byFeedID(id: id, pretty: pretty))
    }
    
    /// This call returns everything we know about the feed from the feed URL
    ///
    /// - parameter id: (Required) PodcastIndex Feed URL
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging. Parameter shall not have a value
    /// - returns: a `Podcast` object containing information about the feed.
    public func podcast(byFeedUrl url: String, pretty: Bool = false) async throws -> PodcastResponse {
        try await router.execute(.byFeedURL(url: url, pretty: pretty))
    }
    
    /// This call returns everything we know about the feed from the feed's GUID.
    /// The GUID is a unique, global identifier for the podcast. See the namespace spec for
    /// [guid](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#guid) for details.
    ///
    /// - parameter guid: (Required) The GUID from the podcast:guid tag in the feed. This value is a unique, global identifier for the podcast.
    /// See the namespace spec for
    /// [guid](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#guid) for details.
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging. Parameter shall not have a value
    /// - returns: a `Podcast` object containing information about the feed.
    public func podcast(byGuid guid: String, pretty: Bool = false) async throws -> PodcastResponse {
        try await router.execute(.byGUID(guid: guid, pretty: pretty))
    }
    
    /// This call returns everything we know about the feed from the iTunes ID
    ///
    /// - parameter id: (Required) The iTunes Feed ID to search for
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging. Parameter shall not have a value
    /// - returns: a `Podcast` object containing information about the feed.
    public func podcast(byItunesId id: Int, pretty: Bool = false) async throws -> PodcastResponse {
        try await router.execute(.byItunesID(id: id, pretty: pretty))
    }
    
    /// This call returns all feeds that support the specified
    /// [podcast namespace tag](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md).
    ///
    /// When called without a start_at value, the top 500 feeds sorted by popularity are returned in descending order.
    ///
    /// When called with a start_at value, the feeds are returned sorted by the feedId starting with the specified value
    /// up to the max number of feeds to return. The nextStartAt specifies the value to pass to the next start_at.
    /// Repeat this sequence until no items are returned.
    ///
    ///- parameter podcast-value: (Required) Get feeds supporting the value tag.
    ///Parameter shall not have a value
    ///- parameter max: Maximum number of results to return.
    ///- parameter start_at: Feed ID to start at for request
    ///- parameter pretty: If present, makes the output “pretty” to help with debugging.
    ///Parameter shall not have a value
    ///- returns: a  `PodcastArrayResponse` object which has an array of `Podcast`s
    public func podcastByTag(max: Int? = nil, startAt: String? = nil, pretty: Bool = false) async throws -> PodcastArrayResponse {
        try await router.execute(.byTag(max: max, startAt: startAt, pretty: pretty))
    }
    
    /// This call returns all feeds marked with the specified [medium](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#medium) tag value.
    ///- parameter medium: (Required) The medium value to search for.
    /// Full list of possible values documented in [medium](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#medium) tag spec.
    ///- parameter max: Maximum number of results to return.
    ///- parameter start_at: Feed ID to start at for request
    ///- parameter pretty: If present, makes the output “pretty” to help with debugging.
    ///Parameter shall not have a value
    ///- returns: a  `PodcastArrayResponse` object which has an array of `Podcast`s
    public func podcast(byMedium medium: String, max: Int? = nil, pretty: Bool = false) async throws -> PodcastArrayResponse {
        try await router.execute(.byMedium(medium: medium, max: max, pretty: pretty))
    }
    
    /// This call returns the podcasts/feeds that in the index that are trending.
    /// - parameter max: Maximum number of results to return.
    /// - parameter since: Return items since the specified time. The value can be a unix epoch timestamp or a negative integer that represents a number of seconds prior to right now.
    /// - parameter lang: Specifying a language code (like "en") will return only episodes having that specific language.
    /// You can specify multiple languages by separating them with commas.
    /// If you also want to return episodes that have no language given, use the token "unknown". (ex. en,es,ja,unknown).
    /// Values are not case sensitive.
    /// - parameter cat: Use this argument to specify that you ONLY want episodes with these categories in the results.
    /// Separate multiple categories with commas.
    /// You may specify either the Category ID and/or the Category Name.
    /// Values are not case sensitive.
    /// The cat and notcat filters can be used together to fine tune a very specific result set.
    /// Category numbers and names can be found in the [Podcast Namespace documentation](https://github.com/Podcastindex-org/podcast-namespace/blob/main/categories.json)
    /// - parameter notcat: Use this argument to specify categories of episodes to NOT show in the results.
    /// Separate multiple categories with commas.
    /// You may specify either the Category ID and/or the Category Name.
    /// Values are not case sensitive.
    /// The cat and notcat filters can be used together to fine tune a very specific result set.
    /// Category numbers and names can be found in the [Podcast Namespace documentation](https://github.com/Podcastindex-org/podcast-namespace/blob/main/categories.json)
    ///- parameter pretty: If present, makes the output “pretty” to help with debugging.
    ///- returns: a  `PodcastArrayResponse` object which has an array of `Podcast`s
    public func trendingPodcasts(max: Int? = nil, since: Date? = nil, lang: String? = nil, cat: String? = nil, notcat: String? = nil, pretty: Bool = false) async throws -> PodcastArrayResponse {
        try await router.execute(.trending(max: max, since: since, lang: lang, cat: cat, notcat: notcat, pretty: pretty))
    }
    
    /// This call returns all feeds that have been marked dead (dead == 1)
    /// Dead feeds can also be accessed from object storage at [https://public.podcastindex.org/podcastindex_dead_feeds.csv](https://public.podcastindex.org/podcastindex_dead_feeds.csv)
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging.
    /// Parameter shall not have a value
    ///- returns: a  `PodcastArrayResponse` object which has an array of `Podcast`s
    public func deadPodcasts(pretty: Bool = false) async throws -> PodcastArrayResponse {
        try await router.execute(.dead(pretty: pretty))
    }
}

enum PodcastsAPI {
    case byFeedID(id: Int, pretty: Bool)
    case byFeedURL(url: String, pretty: Bool)
    case byGUID(guid: String, pretty: Bool)
    case byItunesID(id: Int, pretty: Bool)
    case byTag(max: Int?, startAt: String?, pretty: Bool)
    case byMedium(medium: String, max: Int?, pretty: Bool)
    case trending(max: Int?, since: Date?, lang: String?, cat: String?, notcat: String?, pretty: Bool)
    case dead(pretty: Bool)
}

extension PodcastsAPI: EndpointType {
    public var baseURL: URL {
        guard let url = URL(string: indexURL) else { fatalError("baseURL not configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .byFeedID: "/podcasts/byfeedid"
        case .byFeedURL: "/podcasts/byfeedurl"
        case .byGUID: "/podcasts/byguid"
        case .byItunesID: "/podcasts/byitunesid"
        case .byTag: "/podcasts/bytag"
        case .byMedium: "/podcasts/bymedium"
        case .trending: "/podcasts/trending"
        case .dead: "/podcasts/dead"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .byFeedID, .byFeedURL, .byGUID, .byItunesID, .byTag, .byMedium, .trending, .dead: .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .byFeedID(let id, let pretty):
            var parameters: Parameters = ["id" : id]
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        case .byFeedURL(let url, let pretty):
            var parameters: Parameters = ["url" : url]
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        case .byGUID(let guid, let pretty):
            var parameters: Parameters = ["guid" : guid]
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        case .byItunesID(let id, let pretty):
            var parameters: Parameters = ["id" : id]
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        case .byTag(let max, let startAt, let pretty):
            var parameters: Parameters = [:]
            appendNil(toParameters: &parameters, withKey: "podcast-value", forBool: true)
            append(max, toParameters: &parameters, withKey: "max")
            append(startAt, toParameters: &parameters, withKey: "start_at")
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        case .byMedium(let medium, let max, let pretty):
            var parameters: Parameters = ["medium" : medium]
            append(max, toParameters: &parameters, withKey: "max")
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        case .trending(let max, let since, let lang, let cat, let notcat, let pretty):
            var parameters: Parameters = [:]
            append(max, toParameters: &parameters, withKey: "max")
            append(since, toParameters: &parameters, withKey: "since")
            append(lang, toParameters: &parameters, withKey: "lang")
            append(cat, toParameters: &parameters, withKey: "cat")
            append(notcat, toParameters: &parameters, withKey: "notcat")
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        case .dead(let pretty):
            var parameters: Parameters = [:]
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
}

