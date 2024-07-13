/// Podcast Index API response for any endpoint that returns an array of `Episode`s
public struct EpisodeArrayResponse: Codable, Hashable, Sendable {
    private let responseStatus: String?
    
    /// List of live episodes for feed
    public let liveItems: [Episode]?
    
    /// List of episodes matching request
    public let items: [Episode]?
    
    /// Number of items returned in request
    public let count: Int?
    
    public let query: EpisodeResponsesQuery?
        
    /// Description of the response
    public let episodeArrayResponseDescription: String?
    
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
        case liveItems
        case items
        case count
        case query
        case episodeArrayResponseDescription = "description"
    }
}

public enum EpisodeResponsesQuery: Codable, Hashable, Sendable {
    /// Single String ID: Single ID passed to request
    case singleString(String)
    
    /// Multiple String IDs: IDs passed to request
    case multipleStrings([String])
    
    /// Single Int ID: Single ID passed to request
    case singleInt(Int)
    
    /// Multiple Int IDs: IDs passed to request
    case multipleInts([Int])
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let singleString = try? container.decode(String.self) {
            self = .singleString(singleString)
        } else if let singleInt = try? container.decode(Int.self) {
            self = .singleInt(singleInt)
        } else if let stringArray = try? container.decode([String].self) {
            self = .multipleStrings(stringArray)
        } else if let intArray = try? container.decode([Int].self) {
            self = .multipleInts(intArray)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JSON structure encountered")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .singleString(let singleString):
            try container.encode(singleString)
        case .singleInt(let singleInt):
            try container.encode(singleInt)
        case .multipleStrings(let stringArray):
            try container.encode(stringArray)
        case .multipleInts(let intArray):
            try container.encode(intArray)
        }
    }
}
