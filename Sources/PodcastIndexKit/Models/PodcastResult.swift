//
//  PodcastResult.swift
//  
//
//  Created by Thomas Rademaker on 5/8/23.
//

/// Podcast Index API response for any endpoint that returns a single Podcast
public struct PodcastResult: Codable {
    private let resultStatus: String
    
    /// Known details of podcast feed
    public let feed: Podcast
    
    /// Object containing the input query data
    public let query: PodcastResultsQuery
    
    /// Description of the response
    public let description: String
    
    /// Indicates API request status
    /// Allowed: true┃false
    public var status: Bool {
        switch resultStatus.lowercased() {
        case "true": return true
        case "false": return false
        default: return false
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case resultStatus = "status"
        case feed
        case query
        case description
    }
}

public struct PodcastResultsQuery: Codable {
    /// The Podcast Index feed ID for the feed specified by the guid field passed to the request
    public let id: String?
    
    /// Value passed to request in the url field
    public let url: String?
    
    // Value passed to request in the guid field
    // The GUID from the podcast:guid tag in the feed. This value is a unique, global identifier for the podcast. See the namespace spec for [guid](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#guid) for details.
    public let guid: String?
}
