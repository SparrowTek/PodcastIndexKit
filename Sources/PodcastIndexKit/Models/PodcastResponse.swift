/// Podcast Index API response for any endpoint that returns a single `Podcast`
public struct PodcastResponse: Codable, Hashable, Sendable {
    private let responseStatus: String?
    
    /// Known details of podcast feed. `nil` when Podcast Index found none.
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
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        responseStatus = try container.decodeIfPresent(String.self, forKey: .responseStatus)
        feed = try container.decodeIfFound(Podcast.self, forKey: .feed)
        query = try container.decodeIfPresent(PodcastResponsesQuery.self, forKey: .query)
        podcastResponseDescription = try container.decodeIfPresent(String.self, forKey: .podcastResponseDescription)
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
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Podcast Index echoes a feed ID as text and an iTunes ID as a number.
        if let number = try? container.decodeIfPresent(Int.self, forKey: .id) {
            id = String(number)
        } else {
            id = try container.decodeIfPresent(String.self, forKey: .id)
        }
        url = try container.decodeIfPresent(String.self, forKey: .url)
        guid = try container.decodeIfPresent(String.self, forKey: .guid)
    }
}

extension KeyedDecodingContainer {
    /// Decodes the object at `key`, or `nil` when Podcast Index found none.
    ///
    /// A lookup that finds nothing is answered with an empty array where the
    /// object would have been (`"feed": []`, `"episode": []`), not with
    /// `null` and not by leaving the field out.
    func decodeIfFound<Value: Decodable>(_ type: Value.Type, forKey key: Key) throws -> Value? {
        if let nothing = try? nestedUnkeyedContainer(forKey: key), nothing.isAtEnd {
            return nil
        }
        return try decodeIfPresent(type, forKey: key)
    }
}
