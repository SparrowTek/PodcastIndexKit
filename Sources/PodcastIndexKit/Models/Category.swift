public struct Category: Codable, Hashable, Identifiable, Sendable {
	/// The internal PodcastIndex.org category ID.
	public let id: Int?
	
	/// The category name.
	public let name: String?
}
