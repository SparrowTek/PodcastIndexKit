public struct SoundbiteArrayResponse: Codable, Hashable, Sendable {
	private let responseStatus: String
	
	public let count: Int
	public let description: String
	public let items: [Soundbite]
	
	/// Indicates API request status
	/// Allowed: true┃false
	public var status: Bool {
		switch responseStatus.lowercased() {
		case "true": return true
		case "false": return false
		default: return false
		}
	}
	
	enum CodingKeys: String, CodingKey {
		case responseStatus = "status"
		case count
		case description
		case items
	}
}
