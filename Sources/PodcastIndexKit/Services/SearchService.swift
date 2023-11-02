import Foundation

public struct SearchService {
    private let router = NetworkRouter<SearchAPI>(decoder: .podcastIndexDecoder, delegate: routerDelegate)
    
    /// This call returns all of the feeds that match the search terms in the title, author or owner of the feed.
    /// This is ordered by the last-released episode, with the latest at the top of the results.
    /// - parameter q: (Required) Terms to search for
    /// - parameter val: Only returns feeds with a value block of the specified type. Use any to return feeds with any value block.
    /// - parameter max: Maximum number of results to return.
    /// - parameter aponly: Only returns feeds with an `itunesId`.
    /// - parameter clean: If present, only non-explicit feeds will be returned. Meaning, feeds where the itunes:explicit flag is set to false. Parameter shall not have a value
    /// - parameter fulltext: If present, return the full text value of any text fields (ex: description). If not provided, field value is truncated to 100 words. Parameter shall not have a value
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging. Parameter shall not have a value
    /// - returns: a `SearchResults` object which is an array of `Podcast`s.
    public func search(byTerm q: String, val: String? = nil, max: Int? = nil, aponly: Bool? = nil, clean: Bool = false, fulltext: Bool = false, pretty: Bool = false) async throws -> PodcastArrayResponse {
        try await router.execute(.byTerm(q: q, val: val, max: max, aponly: aponly, clean: clean, fulltext: fulltext, pretty: pretty))
    }
    
    /// This call returns all of the feeds where the title of the feed matches the search term (ignores case).
    /// Example "everything everywhere daily" will match the podcast [Everything Everywhere Daily](https://podcastindex.org/podcast/437685) but "everything everywhere" will not.
    /// - parameter q: (Required) Terms to search for
    /// - parameter val: Only returns feeds with a value block of the specified type. Use any to return feeds with any value block.
    /// - parameter max: Maximum number of results to return.
    /// - parameter clean: If present, only non-explicit feeds will be returned. Meaning, feeds where the itunes:explicit flag is set to false. Parameter shall not have a value
    /// - parameter fulltext: If present, return the full text value of any text fields (ex: description). If not provided, field value is truncated to 100 words. Parameter shall not have a value
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging. Parameter shall not have a value
    /// - parameter similar: If present, include similar matches in search response
    /// - returns: a `SearchResults` object which is an array of `Podcast`s.
    public func search(byTitle q: String, val: String? = nil, max: Int? = nil, clean: Bool = false, fulltext: Bool = false, pretty: Bool = false, similar: Bool = false) async throws -> PodcastArrayResponse {
        try await router.execute(.byTitle(q: q, val: val, max: max, clean: clean, fulltext: fulltext, pretty: pretty, similar: similar))
    }
    
    /// This call returns all of the episodes where the specified person is mentioned.
    /// It searches the following fields:
    /// - Person tags
    /// - Episode title
    /// - Episode description
    /// - Feed owner
    /// - Feed author
    /// Examples:
    /// [https://api.podcastindex.org/api/1.0/search/byperson?q=adam%20curry&pretty](https://api.podcastindex.org/api/1.0/search/byperson?q=adam%20curry&pretty)
    /// [https://api.podcastindex.org/api/1.0/search/byperson?q=Martin+Mouritzen&pretty](https://api.podcastindex.org/api/1.0/search/byperson?q=Martin+Mouritzen&pretty)
    /// [https://api.podcastindex.org/api/1.0/search/byperson?q=Klaus+Schwab&pretty](https://api.podcastindex.org/api/1.0/search/byperson?q=Klaus+Schwab&pretty)
    /// - parameter q: (Required) Person to search for
    /// - parameter max: Maximum number of results to return.
    /// - parameter fulltext: If present, return the full text value of any text fields (ex: description). If not provided, field value is truncated to 100 words. Parameter shall not have a value
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging. Parameter shall not have a value
    /// - returns: a `SearchResults` object which is an array of `Podcast`s.
    public func search(byPerson q: String, max: Int? = nil, fulltext: Bool = false, pretty: Bool = false) async throws -> PodcastArrayResponse {
        try await router.execute(.byPerson(q: q, max: max, fulltext: fulltext, pretty: pretty))
    }
    
    /// This call returns all of the feeds that match the search terms in the title, author or owner of the where the [medium](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#medium) is music.
    /// - parameter q: (Required) Terms to search for
    /// - parameter val: Only returns feeds with a value block of the specified type. Use any to return feeds with any value block.
    /// - parameter max: Maximum number of results to return.
    /// - parameter aponly: Only returns feeds with an `itunesId`.
    /// - parameter clean: If present, only non-explicit feeds will be returned. Meaning, feeds where the itunes:explicit flag is set to false. Parameter shall not have a value
    /// - parameter fulltext: If present, return the full text value of any text fields (ex: description). If not provided, field value is truncated to 100 words. Parameter shall not have a value
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging. Parameter shall not have a value
    /// - returns: a `SearchResults` object which is an array of `Podcast`s.
    public func searchMusic(byTerm q: String, val: String? = nil, max: Int? = nil, aponly: Bool? = nil, clean: Bool = false, fulltext: Bool = false, pretty: Bool = false) async throws -> PodcastArrayResponse {
        try await router.execute(.musicByTerm(q: q, val: val, max: max, aponly: aponly, clean: clean, fulltext: fulltext, pretty: pretty))
    }
}

enum SearchAPI {
    case byTerm(q: String, val: String?, max: Int?, aponly: Bool?, clean: Bool, fulltext: Bool, pretty: Bool)
    case byTitle(q: String, val: String?, max: Int?, clean: Bool, fulltext: Bool, pretty: Bool, similar: Bool)
    case byPerson(q: String, max: Int?, fulltext: Bool, pretty: Bool)
    case musicByTerm(q: String, val: String?, max: Int?, aponly: Bool?, clean: Bool, fulltext: Bool, pretty: Bool)
}

extension SearchAPI: EndpointType {
    public var baseURL: URL {
        guard let url = URL(string: indexURL) else { fatalError("baseURL not configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .byTerm: "/search/byterm"
        case .byTitle: "/search/bytitle"
        case .byPerson: "/search/byperson"
        case .musicByTerm: "/search/music/byterm"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .byTerm, .byTitle, .byPerson, .musicByTerm: .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .byTerm(let q, let val, let max, let aponly, let clean, let fulltext, let pretty):
            var parameters: Parameters = ["q" : q]
            append(val, toParameters: &parameters, withKey: "val")
            append(max, toParameters: &parameters, withKey: "max")
            append(aponly, toParameters: &parameters, withKey: "aponly")
            appendNil(toParameters: &parameters, withKey: "clean", forBool: clean)
            appendNil(toParameters: &parameters, withKey: "fulltext", forBool: fulltext)
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        case .byTitle(let q, let val, let max, let clean, let fulltext, let pretty, let similar):
            var parameters: Parameters = ["q" : q]
            append(val, toParameters: &parameters, withKey: "val")
            append(max, toParameters: &parameters, withKey: "max")
            appendNil(toParameters: &parameters, withKey: "clean", forBool: clean)
            appendNil(toParameters: &parameters, withKey: "fulltext", forBool: fulltext)
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            appendNil(toParameters: &parameters, withKey: "similar", forBool: similar)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        case .byPerson(let q, let max, let fulltext, let pretty):
            var parameters: Parameters = ["q" : q]
            append(max, toParameters: &parameters, withKey: "max")
            appendNil(toParameters: &parameters, withKey: "fulltext", forBool: fulltext)
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        case .musicByTerm(let q, let val, let max, let aponly, let clean, let fulltext, let pretty):
            var parameters: Parameters = ["q" : q]
            append(val, toParameters: &parameters, withKey: "val")
            append(max, toParameters: &parameters, withKey: "max")
            append(aponly, toParameters: &parameters, withKey: "aponly")
            appendNil(toParameters: &parameters, withKey: "clean", forBool: clean)
            appendNil(toParameters: &parameters, withKey: "fulltext", forBool: fulltext)
            appendNil(toParameters: &parameters, withKey: "pretty", forBool: pretty)
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
}

