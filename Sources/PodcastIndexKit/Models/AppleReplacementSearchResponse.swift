public struct AppleReplacementSearchResponse: Codable, Hashable, Sendable {
	/// Number of items returned in request
	public let resultCount: Int
	
	/// List of feeds matching request
	public let results: [AppleReplacementPodcast]
}
