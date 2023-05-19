public struct SoundbiteArrayResponse: Codable {
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
}
