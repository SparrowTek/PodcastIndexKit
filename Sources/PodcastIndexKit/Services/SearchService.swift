//
//  SearchService.swift
//  
//
//  Created by Thomas Rademaker on 5/7/23.
//

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
    public func search(byTerm q: String, val: String? = nil, max: Int? = nil, aponly: Bool? = nil, clean: Bool? = nil, fulltext: Bool? = nil, pretty: Bool? = nil) async throws -> PodcastArrayResult {
        try await search(path: "byterm", q: q, val: val, aponly: aponly, max: max, clean: clean, fulltext: fulltext, pretty: pretty)
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
    public func search(byTitle q: String, val: String? = nil, max: Int? = nil, clean: Bool? = nil, fulltext: Bool? = nil, pretty: Bool? = nil, similar: Bool? = nil) async throws -> PodcastArrayResult {
        try await search(path: "bytitle", q: q, val: val, max: max, clean: clean, fulltext: fulltext, pretty: pretty, similar: similar)
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
    public func search(byPerson q: String, max: Int? = nil, fulltext: Bool? = nil, pretty: Bool? = nil) async throws -> PodcastArrayResult {
        try await search(path: "byperson", q: q, max: max, fulltext: fulltext, pretty: pretty)
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
    public func searchMusic(byTerm q: String, val: String? = nil, max: Int? = nil, aponly: Bool? = nil, clean: Bool? = nil, fulltext: Bool? = nil, pretty: Bool? = nil) async throws -> PodcastArrayResult {
        try await search(path: "music/byterm", q: q, val: val, aponly: aponly, max: max, clean: clean, fulltext: fulltext, pretty: pretty)
    }
    
    /// Helper method to facilitate all search methods
    /// - parameter path: the path to append to the base path
    /// - parameter q: (Required) Terms to search for
    /// - parameter val: Only returns feeds with a value block of the specified type. Use any to return feeds with any value block.
    /// - parameter aponly: Only returns feeds with an `itunesId`.
    /// - parameter max: Maximum number of results to return.
    /// - parameter clean: If present, only non-explicit feeds will be returned. Meaning, feeds where the itunes:explicit flag is set to false. Parameter shall not have a value
    /// - parameter fulltext: If present, return the full text value of any text fields (ex: description). If not provided, field value is truncated to 100 words. Parameter shall not have a value
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging. Parameter shall not have a value
    /// - parameter similar: If present, include similar matches in search response
    /// - returns: a `SearchResults` object which is an array of `Podcast`s.
    private func search(path: String, q: String, val: String? = nil, aponly: Bool? = nil, max: Int? = nil, clean: Bool? = nil, fulltext: Bool? = nil, pretty: Bool? = nil, similar: Bool? = nil) async throws -> PodcastArrayResult {
        var query: [(String, String?)]? = [("q", q)]
        
        if let val {
            query?.append(("val", val))
        }
        
        if let max {
            query?.append(("max", "\(max)"))
        }
        
        if let aponly {
            query?.append(("aponly", "\(aponly)"))
        }
        
        if let clean, clean == true {
            query?.append(("clean", nil))
        }
        
        if let fulltext, fulltext == true {
            query?.append(("fulltext", nil))
        }
        
        if let pretty, pretty == true {
            query?.append(("pretty", nil))
        }
        
        if let similar, similar == true {
            query?.append(("similar", nil))
        }
        
        return try await apiClient.send(Request(path: "\(basePath)/\(path)", query: query)).value
    }
}
