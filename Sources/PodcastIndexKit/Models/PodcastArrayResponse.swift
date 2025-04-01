/// Podcast Index API response for any endpoint that returns an array of Podcasts
public struct PodcastArrayResponse: Codable, Hashable, Sendable {
    private let responseStatus: String?
    
    /// List of feeds matching request
    public let feeds: [Podcast]
    
    /// Number of items returned in request
    public let count: Int?
    
    /// Search terms passed to request
    public let query: String?
    
    /// Description of the response
    public let podcastArrayResponseDescription: String?
    
    
    /// Indicates API request status
    /// Allowed: true┃false
    public var status: Bool {
        switch responseStatus?.lowercased() {
        case "true": return true
        case "false": return false
        default: return false
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        responseStatus = try container.decodeIfPresent(String.self, forKey: .responseStatus)
        count = try container.decodeIfPresent(Int.self, forKey: .count)
        query = try container.decodeIfPresent(String.self, forKey: .query)
        podcastArrayResponseDescription = try container.decodeIfPresent(String.self, forKey: .podcastArrayResponseDescription)
        
        // Try decoding 'feeds' first, if that fails, try 'items'
        feeds = if let feeds = try? container.decodeIfPresent([Podcast].self, forKey: .feeds) {
            feeds
        } else if let items = try? container.decodeIfPresent([Podcast].self, forKey: .items) {
            items
        } else {
            []
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(responseStatus, forKey: .responseStatus)
        try container.encodeIfPresent(count, forKey: .count)
        try container.encodeIfPresent(query, forKey: .query)
        try container.encodeIfPresent(podcastArrayResponseDescription, forKey: .podcastArrayResponseDescription)
        
        // When encoding, always use 'feeds' key for consistency
        try container.encode(feeds, forKey: .feeds)
    }
    
    enum CodingKeys: String, CodingKey {
        case responseStatus = "status"
        case feeds, items
        case count
        case query
        case podcastArrayResponseDescription = "description"
    }
}
