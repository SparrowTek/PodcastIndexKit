public struct SoundbiteArrayResponse: Codable {
	private let resultStatus: String
	
	public let count: Int
	public let description: String
	public let items: [Soundbite]
	
	/// Indicates API request status
	/// Allowed: true┃false
	public var status: Bool {
		switch resultStatus.lowercased() {
		case "true": return true
		case "false": return false
		default: return false
		}
	}
}
