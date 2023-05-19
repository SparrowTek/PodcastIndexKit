import Get

public struct SearchService {
    private let apiClient = APIClient(configuration: configuration)
    private let basePath = "/search"
    
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
        var query: [(String, String?)]? = [("q", q)]
        append(val, toQuery: &query, withKey: "val")
        append(max, toQuery: &query, withKey: "max")
        append(aponly, toQuery: &query, withKey: "aponly")
        appendNil(toQuery: &query, withKey: "clean", forBool: clean)
        appendNil(toQuery: &query, withKey: "fulltext", forBool: fulltext)
        appendNil(toQuery: &query, withKey: "pretty", forBool: pretty)
                
        return try await apiClient.send(Request(path: "\(basePath)/byterm", query: query)).value
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
        var query: [(String, String?)]? = [("q", q)]
        append(val, toQuery: &query, withKey: "val")
        append(max, toQuery: &query, withKey: "max")
        appendNil(toQuery: &query, withKey: "clean", forBool: clean)
        appendNil(toQuery: &query, withKey: "fulltext", forBool: fulltext)
        appendNil(toQuery: &query, withKey: "pretty", forBool: pretty)
        appendNil(toQuery: &query, withKey: "similar", forBool: similar)
        
        return try await apiClient.send(Request(path: "\(basePath)/bytitle", query: query)).value
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
        var query: [(String, String?)]? = [("q", q)]
        append(max, toQuery: &query, withKey: "max")
        appendNil(toQuery: &query, withKey: "fulltext", forBool: fulltext)
        appendNil(toQuery: &query, withKey: "pretty", forBool: pretty)
        
        return try await apiClient.send(Request(path: "\(basePath)/byperson", query: query)).value
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
        var query: [(String, String?)]? = [("q", q)]
        append(val, toQuery: &query, withKey: "val")
        append(max, toQuery: &query, withKey: "max")
        append(aponly, toQuery: &query, withKey: "aponly")
        appendNil(toQuery: &query, withKey: "clean", forBool: clean)
        appendNil(toQuery: &query, withKey: "fulltext", forBool: fulltext)
        appendNil(toQuery: &query, withKey: "pretty", forBool: pretty)
        
        return try await apiClient.send(Request(path: "\(basePath)/music/byterm", query: query)).value
    }
}
