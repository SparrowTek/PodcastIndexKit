public struct StatsResponse: Codable {
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
	
	/// An array statistic properties
	public let stats: [StatProperties]
	
	/// Description of the response
	public let description: String
	
	enum CodingKeys: String, CodingKey {
		case responseStatus = "status"
		case stats
		case description
	}
}