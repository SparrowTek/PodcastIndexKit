public struct ValueResponse: Codable, Hashable, Sendable {
	private let responseStatus: String
	
	/// Indicates API request status
	/// Allowed: true┃false
	public var status: Bool {
		switch responseStatus.lowercased() {
		case "true": return true
		case "false": return false
		default: return false
		}
	}
	
	/// Object containing the input query data
	public let query: ValueQuery
	
	/// Information for supporting the podcast via one of the "Value for Value" methods.
	/// Examples:
	/// lightning value type: [https://api.podcastindex.org/api/1.0/podcasts/byfeedid?id=169991&pretty](https://api.podcastindex.org/api/1.0/podcasts/byfeedid?id=169991&pretty)
	/// webmonetization value type: [https://api.podcastindex.org/api/1.0/podcasts/byfeedid?id=779873&pretty](https://api.podcastindex.org/api/1.0/podcasts/byfeedid?id=779873&pretty)
	public let value: Value
	
	/// Description of the response
	public let description: String
	
	enum CodingKeys: String, CodingKey {
		case responseStatus = "status"
		case query
		case value
		case description
	}
}
