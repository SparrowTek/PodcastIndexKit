/// Podcast Index API response for any endpoint that returns a single `Podcast`
public struct PodcastResponse: Codable, Hashable, Sendable {
    private let responseStatus: String?
    
    /// Known details of podcast feed
    public let feed: Podcast?
    
    /// Object containing the input query data
    public let query: PodcastResponsesQuery?
    
    /// Description of the response
    public let podcastResponseDescription: String?
    
    /// Indicates API request status
    /// Allowed: true┃false
    public var status: Bool {
        switch responseStatus?.lowercased() {
        case "true": return true
        case "false": return false
        default: return false
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case responseStatus = "status"
        case feed
        case query
        case podcastResponseDescription = "description"
    }
}

public struct PodcastResponsesQuery: Codable, Hashable, Sendable {
    /// The Podcast Index feed ID for the feed specified by the guid field passed to the request
    public let id: String?
    
    /// Value passed to request in the url field
    public let url: String?
    
    // Value passed to request in the guid field
    // The GUID from the podcast:guid tag in the feed. This value is a unique, global identifier for the podcast. See the namespace spec for [guid](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#guid) for details.
    public let guid: String?
}
