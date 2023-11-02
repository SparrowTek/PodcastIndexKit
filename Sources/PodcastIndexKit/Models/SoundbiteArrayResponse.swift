public struct SoundbiteArrayResponse: Codable, Hashable, Sendable {
	private let responseStatus: String?
	
	/// Number of items returned in request
	public let count: Int?
	
	/// Description of the response
	public let soundbiteArrayResponseDescription: String?
	
	/// List of soundbites matching request
	public let items: [Soundbite]?
	
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
		case count
		case soundbiteArrayResponseDescription = "description"
		case items
	}
}
