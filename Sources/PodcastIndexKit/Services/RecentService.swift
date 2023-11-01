import Foundation

public struct RecentService {
    private let router = NetworkRouter<RecentAPI>(decoder: .podcastIndexDecoder, delegate: routerDelegate)
    
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
    /// - returns: an `EpisodeArrayResponse` object containing an array of `Episode`s.
    public func recentEpisodes(max: Int? = nil, excludeString: String? = nil, before: Date? = nil, fulltext: Bool = false, pretty: Bool = false) async throws -> EpisodeArrayResponse {
        try await router.execute(.episodes(max: max, excludeString: excludeString, before: before, fulltext: fulltext, pretty: pretty))
    }
    
    /// This call returns the most recent max feeds, in reverse chronological order.
    ///
    ///- parameter max: Maximum number of results to return.
    ///- parameter since: Return items since the specified time. The value can be a unix epoch timestamp or a negative integer that represents a number of seconds prior to right now.
    ///- parameter lang: Specifying a language code (like "en") will return only episodes having that specific language.
    /// You can specify multiple languages by separating them with commas.
    /// If you also want to return episodes that have no language given, use the token "unknown". (ex. en,es,ja,unknown).
    /// Values are not case sensitive.
    ///- parameter cat: Use this argument to specify that you ONLY want episodes with these categories in the results.
    /// Separate multiple categories with commas.
    /// You may specify either the Category ID and/or the Category Name.
    /// Values are not case sensitive.
    /// The cat and notcat filters can be used together to fine tune a very specific result set.
    /// Category numbers and names can be found in the [Podcast Namespace documentation](https://github.com/Podcastindex-org/podcast-namespace/blob/main/categories.json)
    ///- parameter notcat: Use this argument to specify categories of episodes to NOT show in the results.
    /// Separate multiple categories with commas.
    /// You may specify either the Category ID and/or the Category Name.
    /// Values are not case sensitive.
    /// The cat and notcat filters can be used together to fine tune a very specific result set.
    /// Category numbers and names can be found in the [Podcast Namespace documentation](https://github.com/Podcastindex-org/podcast-namespace/blob/main/categories.json)
    ///- parameter pretty: If present, makes the output “pretty” to help with debugging.
    /// Parameter shall not have a value
    ///- returns: a  `PodcastArrayResponse` object which has an array of `Podcast`s
    public func recentFeeds(max: Int? = nil, since: Date? = nil, lang: String? = nil, cat: String? = nil, notcat: String? = nil, pretty: Bool = false) async throws -> PodcastArrayResponse {
        try await router.execute(.feeds(max: max, since: since, lang: lang, cat: cat, notcat: notcat, pretty: pretty))
    }
    
    /// This call returns every new feed added to the index over the past 24 hours in reverse chronological order.
    ///
    ///- parameter max: Maximum number of results to return.
    ///- parameter since: Return items since the specified time. The value can be a unix epoch timestamp or a negative integer that represents a number of seconds prior to right now.
    ///- parameter feedid: The PodcastIndex Feed ID to start from (or go to if desc specified).
    /// If since parameter also specified, value of since is ignored.
    ///- parameter desc: If present, display feeds in descending order.
    /// Only applicable when using feedid parameter.
    /// Parameter shall not have a value
    ///- parameter pretty: If present, makes the output “pretty” to help with debugging.
    /// Parameter shall not have a value
    ///- returns: a  `PodcastArrayResponse` object which has an array of `Podcast`s
    public func recentNewFeeds(max: Int? = nil, since: Date? = nil, feedid: String? = nil, desc: Bool = false, pretty: Bool = false) async throws -> PodcastArrayResponse {
        try await router.execute(.newFeeds(max: max, since: since, feedid: feedid, desc: desc, pretty: pretty))
    }
    
    /// This call returns every new feed added to the index over the past 24 hours in reverse chronological order.
    /// This is similar to /recent/feeds but uses the date the feed was found by the index rather than the feed's internal timestamp.
    /// Similar data can also be accessed using object storage root url [https://tracking.podcastindex.org/current](https://tracking.podcastindex.org/current)
    ///
    ///- parameter max: Maximum number of results to return (includes both feeds and items).
    ///- parameter since: Return items since the specified epoch timestamp.
    ///- parameter pretty: If present, makes the output “pretty” to help with debugging.
    /// Parameter shall not have a value
    ///- returns: a `DataResponse` object
    public func recentData(max: Int? = nil, since: Date? = nil, pretty: Bool = false) async throws -> DataResponse {
        try await router.execute(.data(max: max, since: since, pretty: pretty))
    }
    
    /// This call returns the most recent max soundbites that the index has discovered.
    /// A soundbite consists of an enclosure url, a start time and a duration. It is documented in the [podcast namespace](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#soundbite).
    ///
    ///- parameter max: Maximum number of soundbites to return.
    ///- parameter pretty: If present, makes the output “pretty” to help with debugging.
    /// Parameter shall not have a value
    ///- returns: a `SoundbiteArrayResponse` object which contains an array of `Soundbite`s
    public func recentSoundbites(max: Int? = nil, pretty: Bool = false) async throws -> SoundbiteArrayResponse {
        try await router.execute(.soundBites(max: max, pretty: pretty))
    }
}

enum RecentAPI {
    case episodes(max: Int?, excludeString: String?, before: Date?, fulltext: Bool, pretty: Bool)
    case feeds(max: Int?, since: Date?, lang: String?, cat: String?, notcat: String?, pretty: Bool)
    case newFeeds(max: Int?, since: Date?, feedid: String?, desc: Bool, pretty: Bool)
    case data(max: Int?, since: Date?, pretty: Bool)
    case soundBites(max: Int?, pretty: Bool)
}

extension RecentAPI: EndpointType {
    public var baseURL: URL {
        guard let url = URL(string: indexURL) else { fatalError("baseURL not configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .episodes: "/recent/episodes"
        case .feeds: "/recent/feeds"
        case .newFeeds: "/recent/newfeeds"
        case .data: "/recent/data"
        case .soundBites: "/recent/soundbites"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .episodes, .feeds, .newFeeds, .data, .soundBites: .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .episodes(let max, let excludeString, let before, let fulltext, let pretty):
            var parameters: Parameters = [:]
            append(max, toParameters: &parameters, withKey: "max")
            append(excludeString, toParameters: &parameters, withKey: "excludeString")
            append(before, toParameters: &parameters, withKey: "before")
            appendNil(toParameters: &parameters, withKey: "fulltext", forBool: fulltext)
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        case .feeds(let max, let since, let lang, let cat, let notcat, let pretty):
            var parameters: Parameters = [:]
            append(max, toParameters: &parameters, withKey: "max")
            append(since, toParameters: &parameters, withKey: "since")
            append(lang, toParameters: &parameters, withKey: "lang")
            append(cat, toParameters: &parameters, withKey: "cat")
            append(notcat, toParameters: &parameters, withKey: "notcat")
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        case .newFeeds(let max, let since, let feedid, let desc, let pretty):
            var parameters: Parameters = [:]
            append(max, toParameters: &parameters, withKey: "max")
            append(since, toParameters: &parameters, withKey: "since")
            append(feedid, toParameters: &parameters, withKey: "feedid")
            appendNil(toParameters: &parameters, withKey: "desc", forBool: desc)
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        case .data(let max, let since, let pretty):
            var parameters: Parameters = [:]
            append(max, toParameters: &parameters, withKey: "max")
            append(since, toParameters: &parameters, withKey: "since")
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        case .soundBites(let max, let pretty):
            var parameters: Parameters = [:]
            append(max, toParameters: &parameters, withKey: "max")
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
}

