//
//  PodcastsService.swift
//  
//
//  Created by Thomas Rademaker on 5/8/23.
//

import Get

public struct PodcastsService {
    private let apiClient = APIClient(configuration: configuration)
    private let basePath = "/podcasts"
    
    /// This call returns everything we know about the feed from the PodcastIndex Feed ID
    ///
    /// - parameter id: (Required) The PodcastIndex Feed ID
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging. Parameter shall not have a value
    /// - returns: a `Podcast` object containing information about the feed.
    public func podcast(byFeedId id: Int, pretty: Bool? = nil) async throws -> PodcastsResult {
        try await podcast(path: "byfeedid", q: ("id", "\(id)"))
    }
    
    /// This call returns everything we know about the feed from the feed URL
    ///
    /// - parameter id: (Required) PodcastIndex Feed URL
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging. Parameter shall not have a value
    /// - returns: a `Podcast` object containing information about the feed.
    public func podcast(byFeedUrl url: String, pretty: Bool? = nil) async throws -> PodcastsResult {
        try await podcast(path: "byfeedurl", q: ("url", url))
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
    public func podcast(byGuid guid: String, pretty: Bool? = nil) async throws -> PodcastsResult {
        try await podcast(path: "byguid", q: ("guid", guid))
    }
    
    /// This call returns everything we know about the feed from the iTunes ID
    ///
    /// - parameter id: (Required) The iTunes Feed ID to search for
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging. Parameter shall not have a value
    /// - returns: a `Podcast` object containing information about the feed.
    public func podcast(byItunesId id: Int, pretty: Bool? = nil) async throws -> PodcastsResult {
        try await podcast(path: "byitunesid", q: ("id", "\(id)"))
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
    ///- returns: a  `SearchResult` object which has an array of `Podcast`s
//    public func podcastByTag(max: Int? = nil, startAt: String? = nil, pretty: Bool? = nil) async throws -> SearchResult {
//        
//    }
    
    /// Helper method to facilitate all podcasts methods
    ///
    /// - parameter path: the path to append to the base path
    /// - parameter q: (Required) query to search for
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging. Parameter shall not have a value
    /// - returns: a `PodcastsResult` object which is has an embedded `Podcast`.
    private func podcast(path: String, q: (String, String?), pretty: Bool? = nil) async throws -> PodcastsResult {
        var query: [(String, String?)]? = [q]
        
        if let pretty, pretty == true {
            query?.append(("pretty", nil))
        }
        
        return try await apiClient.send(Request(path: "\(basePath)/\(path)", query: query)).value
    }
}
