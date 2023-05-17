//
//  EpisodesService.swift
//  
//
//  Created by Thomas Rademaker on 5/11/23.
//

import Foundation
import Get

public struct EpisodesService {
    private let apiClient = APIClient(configuration: configuration)
    private let basePath = "/episodes"
    
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
    /// - returns: a n`EpisodeArrayResult` object containing an array of `Episode`s.
    public func episodes(byFeedID id: String, since: Date? = nil, max: Int? = nil, enclosure: String? = nil, fulltext: Bool = false, pretty: Bool = false) async throws -> EpisodeArrayResult {
        var query: [(String, String?)]? = [("id", id)]
        
        if let max {
            query?.append(("max", "\(max)"))
        }
        
        if let since {
            query?.append(("since", "\(since)"))
        }
        
        if let enclosure {
            query?.append(("enclosure", enclosure))
        }
        
        if fulltext {
            query?.append(("fulltext", nil))
        }
        
        if pretty {
            query?.append(("pretty", nil))
        }
        
        return try await apiClient.send(Request(path: "\(basePath)/byfeedid", query: nil)).value
    }
    
    /// This call returns all the episodes we know about for this feed from the feed URL. Episodes are in reverse chronological order.
    ///
    /// - parameter url: (Required) Podcast feed URL
    /// - parameter since: Return items since the specified time. The value can be a unix epoch timestamp or a negative integer that represents a number of seconds prior to right now.
    /// - parameter max: Maximum number of results to return.
    /// - parameter fulltext: If present, return the full text value of any text fields (ex: description). If not provided, field value is truncated to 100 words.
    /// Parameter shall not have a value
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging.
    /// - returns: a n`EpisodeArrayResult` object containing an array of `Episode`s.
    public func episodes(byFeedURL url: String, since: Date? = nil, max: Int? = nil, fulltext: Bool = false, pretty: Bool = false) async throws -> EpisodeArrayResult {
        var query: [(String, String?)]? = [("url", url)]
        
        if let max {
            query?.append(("max", "\(max)"))
        }
        
        if let since {
            query?.append(("since", "\(since)"))
        }
        
        if fulltext {
            query?.append(("fulltext", nil))
        }
        
        if pretty {
            query?.append(("pretty", nil))
        }
        
        return try await apiClient.send(Request(path: "\(basePath)/byfeedurl", query: nil)).value
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
    /// - returns: a n`EpisodeArrayResult` object containing an array of `Episode`s.
    
    
    
    
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
    /// - returns: a n`EpisodeArrayResult` object containing an array of `Episode`s.
    
    
    /// Get all the metadata for a single episode by passing its id.
    ///
    /// - parameter id: (Required) The PodcastIndex episode ID to search for.
    /// - parameter fulltext: If present, return the full text value of any text fields (ex: description). If not provided, field value is truncated to 100 words.
    /// Parameter shall not have a value
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging.
    /// Parameter shall not have a value
    /// - returns: a n`EpisodeArrayResult` object containing an array of `Episode`s.
    
    
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
    /// - returns: a n`EpisodeArrayResult` object containing an array of `Episode`s.
    
    
    
    /// Get all episodes that have been found in the podcast:liveitem from the feeds.
    ///
    ///- parameter max: Maximum number of results to return.
    ///- parameter pretty: If present, makes the output “pretty” to help with debugging.
    ///Parameter shall not have a value
    /// - returns: a n`EpisodeArrayResult` object containing an array of `Episode`s.
    
    
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
    /// - returns: a n`EpisodeArrayResult` object containing an array of `Episode`s.
}
