//
//  EpisodeArrayResult.swift
//  
//
//  Created by Thomas Rademaker on 5/16/23.
//

/// Podcast Index API response for any endpoint that returns an array of `Episode`s
public struct EpisodeArrayResult: Codable {
    private let resultStatus: String
    
    /// List of live episodes for feed
    public let liveItems: [Episode]?
    
    /// List of episodes matching request
    public let items: [Episode]
    
    /// Number of items returned in request
    public let count: Int
    
    public let query: EpisodeResultsQuery
        
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
        case liveItems
        case items
        case count
        case query
        case description
    }
}

public enum EpisodeResultsQuery: Codable {
    /// Single ID: Single ID passed to request
    case single(String)
    
    /// Multiple IDs: IDs passed to request
    case multiple([String])
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let singleString = try? container.decode(String.self) {
            self = .single(singleString)
        }
        else if let stringArray = try? container.decode([String].self) {
            self = .multiple(stringArray)
        }
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JSON structure encountered")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .single(let singleString):
            try container.encode(singleString)
        case .multiple(let stringArray):
            try container.encode(stringArray)
        }
    }
}
