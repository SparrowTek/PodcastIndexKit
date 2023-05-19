public struct RandomEpisodeResponse: Codable {
	private let resultStatus: String
	
	/// List of episodes matching request
	public let episodes: [Episode]
	
	/// Number of items returned in request
	public let count: Int
	
	/// Value of max parameter passed to request.
	public let max: Int	
		
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
		case episodes
		case count
		case max
		case description
	}
}