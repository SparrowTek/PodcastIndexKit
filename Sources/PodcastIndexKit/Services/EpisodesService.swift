import Foundation

public struct EpisodesService {
    private let router = NetworkRouter<EpisodesAPI>(decoder: .podcastIndexDecoder, delegate: routerDelegate)
    
    /// This call returns all the episodes we know about for this feed from the PodcastIndex ID.
    /// Episodes are in reverse chronological order.
    /// When using the enclosure parameter, only the episode matching the URL is returned.
    ///
    /// - parameter id: (Required) The PodcastIndex Feed ID or IDs to search for.
    /// If searching for multiple IDs, separate values with a comma. A maximum of 200 IDs can be provided.
    /// - parameter since: Return items since the specified time. The value can be a unix epoch timestamp or a negative integer that represents a number of seconds prior to right now.
    /// - parameter max: Maximum number of results to return.
    /// - parameter enclosure: The URL for the episode enclosure to get the information for.
    /// - parameter fulltext: If present, return the full text value of any text fields (ex: description). If not provided, field value is truncated to 100 words.
    /// Parameter shall not have a value
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging.
    /// - returns: an `EpisodeArrayResponse` object containing an array of `Episode`s.
    public func episodes(byFeedID id: String, since: Date? = nil, max: Int? = nil, enclosure: String? = nil, fulltext: Bool = false, pretty: Bool = false) async throws -> EpisodeArrayResponse {
        try await router.execute(.byFeedID(id: id, since: since, max: max, enclosure: enclosure, fulltext: fulltext, pretty: pretty))
    }
    
    /// This call returns all the episodes we know about for this feed from the feed URL. Episodes are in reverse chronological order.
    ///
    /// - parameter url: (Required) Podcast feed URL
    /// - parameter since: Return items since the specified time. The value can be a unix epoch timestamp or a negative integer that represents a number of seconds prior to right now.
    /// - parameter max: Maximum number of results to return.
    /// - parameter fulltext: If present, return the full text value of any text fields (ex: description). If not provided, field value is truncated to 100 words.
    /// Parameter shall not have a value
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging.
    /// - returns: an `EpisodeArrayResponse` object containing an array of `Episode`s.
    public func episodes(byFeedURL url: String, since: Date? = nil, max: Int? = nil, fulltext: Bool = false, pretty: Bool = false) async throws -> EpisodeArrayResponse {
        try await router.execute(.byFeedURL(url: url, since: since, max: max, fulltext: fulltext, pretty: pretty))
    }
    
    /// This call returns all the episodes we know about for this feed from the ]Podcast GUID](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#guid).
    /// Episodes are in reverse chronological order.
    ///
    ///- parameter guid: (Required) The GUID from the podcast:guid tag in the feed. This value is a unique, global identifier for the podcast.
    ///See the namespace spec for
    ///[guid](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#guid) for details.
    ///- parameter since: Return items since the specified time. The value can be a unix epoch timestamp or a negative integer that represents a number of seconds prior to right now.
    /// - parameter max: Maximum number of results to return.
    /// - parameter fulltext: If present, return the full text value of any text fields (ex: description). If not provided, field value is truncated to 100 words.
    /// Parameter shall not have a value
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging.
    /// - returns: an `EpisodeArrayResponse` object containing an array of `Episode`s.
    public func episodes(byPodcastGUID guid: String, since: Date? = nil, max: Int? = nil, fulltext: Bool = false, pretty: Bool = false) async throws -> EpisodeArrayResponse {
        try await router.execute(.byPodcastGUID(guid: guid, since: since, max: max, fulltext: fulltext, pretty: pretty))
    }
    
    /// This call returns all the episodes we know about for this feed from the iTunes ID.
    /// Episodes are in reverse chronological order.
    /// When using the enclosure parameter, only the episode matching the URL is returned.
    ///
    /// - parameter id: (Required) The iTunes Feed ID to search for
    /// - parameter since: Return items since the specified time. The value can be a unix epoch timestamp or a negative integer that represents a number of seconds prior to right now.
    /// - parameter max: Maximum number of results to return.
    /// - parameter enclosure: The URL for the episode enclosure to get the information for.
    /// - parameter fulltext: If present, return the full text value of any text fields (ex: description). If not provided, field value is truncated to 100 words.
    /// Parameter shall not have a value
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging.
    /// - returns: an `EpisodeArrayResponse` object containing an array of `Episode`s.
    public func episodes(byiTunesID id: String, since: Date? = nil, max: Int? = nil, enclosure: String? = nil, fulltext: Bool = false, pretty: Bool = false) async throws -> EpisodeArrayResponse {
        try await router.execute(.byItunesID(id: id, since: since, max: max, enclosure: enclosure, fulltext: fulltext, pretty: pretty))
    }
    
    /// Get all the metadata for a single episode by passing its id.
    ///
    /// - parameter id: (Required) The PodcastIndex episode ID to search for.
    /// - parameter fulltext: If present, return the full text value of any text fields (ex: description). If not provided, field value is truncated to 100 words.
    /// Parameter shall not have a value
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging.
    /// Parameter shall not have a value
    /// - returns: an `EpisodeResponse` object containing an `Episode`.
    public func episodes(byID id: String, fulltext: Bool = false, pretty: Bool = false) async throws -> EpisodeResponse {
        try await router.execute(.byID(id: id, fulltext: fulltext, pretty: pretty))
    }
    
    /// Get all the metadata for a single episode by passing its guid and the feed id or URL.
    /// The feedid or the feedurl is required.
    ///
    ///- parameter guid: (Required) The guid value for the episode to retrieve.
    ///This value is the value specified in the feed's <guid> field.
    ///- parameter feedid: The PodcastIndex Feed ID
    ///- parameter feedurl: The Feed URL
    ///- parameter fulltext: If present, return the full text value of any text fields (ex: description). If not provided, field value is truncated to 100 words.
    ///Parameter shall not have a value
    ///- parameter pretty: If present, makes the output “pretty” to help with debugging.
    ///Parameter shall not have a value
    /// - returns: an `EpisodeResponse` object containing an `Episode`.
    public func episodes(byGUID guid: String, feedid: String? = nil, feedurl: String? = nil, fulltext: Bool = false, pretty: Bool = false) async throws -> EpisodeResponse {
        try await router.execute(.byGUID(guid: guid, feedid: feedid, feedurl: feedurl, fulltext: fulltext, pretty: pretty))
    }
    
    /// Get all episodes that have been found in the podcast:liveitem from the feeds.
    ///
    ///- parameter max: Maximum number of results to return.
    ///- parameter pretty: If present, makes the output “pretty” to help with debugging.
    ///Parameter shall not have a value
    /// - returns: an `EpisodeArrayResponse` object containing an array of `Episode`s.
    public func liveEpisodes(max: Int? = nil, pretty: Bool = false) async throws -> EpisodeArrayResponse {
        try await router.execute(.live(max: max, pretty: pretty))
    }
    
    /// This call returns a random batch of episodes, in no specific order.
    ///
    /// - parameter max: Maximum number of results to return.
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
    /// - parameter fulltext: If present, return the full text value of any text fields (ex: description). If not provided, field value is truncated to 100 words.
    /// Parameter shall not have a value
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging.
    /// Parameter shall not have a value
    /// - returns: a `RandomEpisodeResponse` object containing an array of `Episode`s.
    public func randomEpisodes(max: Int? = nil, lang: String? = nil, cat: String? = nil, notcat: String? = nil, fulltext: Bool = false, pretty: Bool = false) async throws -> EpisodeArrayResponse {
        try await router.execute(.random(max: max, lang: lang, cat: cat, notcat: notcat, fulltext: fulltext, pretty: pretty))
    }
}

enum EpisodesAPI {
    case byFeedID(id: String, since: Date?, max: Int?, enclosure: String?, fulltext: Bool, pretty: Bool)
    case byFeedURL(url: String, since: Date?, max: Int?, fulltext: Bool, pretty: Bool)
    case byPodcastGUID(guid: String, since: Date?, max: Int?, fulltext: Bool, pretty: Bool)
    case byItunesID(id: String, since: Date?, max: Int?, enclosure: String?, fulltext: Bool, pretty: Bool)
    case byID(id: String, fulltext: Bool, pretty: Bool)
    case byGUID(guid: String, feedid: String?, feedurl: String?, fulltext: Bool, pretty: Bool)
    case live(max: Int?, pretty: Bool)
    case random(max: Int?, lang: String?, cat: String?, notcat: String?, fulltext: Bool, pretty: Bool)
}

extension EpisodesAPI: EndpointType {
    public var baseURL: URL {
        guard let url = URL(string: indexURL) else { fatalError("baseURL not configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .byFeedID: "/episodes/byfeedid"
        case .byFeedURL: "/episodes/byfeedurl"
        case .byPodcastGUID: "/episodes/bypodcastguid"
        case .byItunesID: "/episodes/byitunesid"
        case .byID: "/episodes/byid"
        case .byGUID: "/episodes/byguid"
        case .live: "/episodes/live"
        case .random: "/episodes/random"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .byFeedID, .byFeedURL, .byPodcastGUID, .byItunesID, .byID, .byGUID, .live, .random: .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .byFeedID(let id, let since, let max, let enclosure, let fulltext, let pretty):
            var parameters: Parameters = ["id" : id]
            append(max, toParameters: &parameters, withKey: "max")
            append(since, toParameters: &parameters, withKey: "since")
            append(enclosure, toParameters: &parameters, withKey: "enclosure")
            appendNil(toParameters: &parameters, withKey: "fulltext", forBool: fulltext)
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        case .byFeedURL(let url, let since, let max, let fulltext, let pretty):
            var parameters: Parameters = ["url" : url]
            append(max, toParameters: &parameters, withKey: "max")
            append(since, toParameters: &parameters, withKey: "since")
            appendNil(toParameters: &parameters, withKey: "fulltext", forBool: fulltext)
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
            
        case .byPodcastGUID(let guid, let since, let max, let fulltext, let pretty):
            var parameters: Parameters = ["guid" : guid]
            append(max, toParameters: &parameters, withKey: "max")
            append(since, toParameters: &parameters, withKey: "since")
            appendNil(toParameters: &parameters, withKey: "fulltext", forBool: fulltext)
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
            
        case .byItunesID(let id, let since, let max, let enclosure, let fulltext, let pretty):
            var parameters: Parameters = ["id" : id]
            append(max, toParameters: &parameters, withKey: "max")
            append(since, toParameters: &parameters, withKey: "since")
            append(enclosure, toParameters: &parameters, withKey: "enclosure")
            appendNil(toParameters: &parameters, withKey: "fulltext", forBool: fulltext)
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
            
        case .byID(let id, let fulltext, let pretty):
            var parameters: Parameters = ["id" : id]
            appendNil(toParameters: &parameters, withKey: "fulltext", forBool: fulltext)
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
            
        case .byGUID(let guid, let feedid, let feedurl, let fulltext, let pretty):
            var parameters: Parameters = ["guid" : guid]
            append(feedid, toParameters: &parameters, withKey: "feedid")
            append(feedurl, toParameters: &parameters, withKey: "feedurl")
            appendNil(toParameters: &parameters, withKey: "fulltext", forBool: fulltext)
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
            
        case .live(let max, let pretty):
            var parameters: Parameters = [:]
            append(max, toParameters: &parameters, withKey: "max")
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
            
        case .random(let max, let lang, let cat, let notcat, let fulltext, let pretty):
            var parameters: Parameters = [:]
            append(max, toParameters: &parameters, withKey: "max")
            append(lang, toParameters: &parameters, withKey: "lang")
            append(cat, toParameters: &parameters, withKey: "cat")
            append(notcat, toParameters: &parameters, withKey: "notcat")
            appendNil(toParameters: &parameters, withKey: "fulltext", forBool: fulltext)
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
}
