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
}
