public struct Category: Codable, Hashable, Sendable {
	/// The internal PodcastIndex.org category ID.
	public let id: Int?
	
	/// The category name.
	public let name: String?
}
