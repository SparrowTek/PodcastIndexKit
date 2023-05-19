/// Podcast Index API response for any endpoint that returns an array of Podcasts
public struct PodcastArrayResponse: Codable {
    private let resultStatus: String
    
    /// List of feeds matching request
    public let feeds: [Podcast]
    
    /// Number of items returned in request
    public let count: Int
    
    /// Search terms passed to request
    public let query: String
    
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
        case feeds
        case count
        case query
        case description
    }
}
