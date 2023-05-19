public struct StatProperties: Codable, Hashable, Sendable {
	/// Total podcast feeds in the index.
	public let feedCountTotal: Int 
	 
	/// Total individual podcast episodes in the index.
	public let episodeCountTotal: Int
	
	/// Podcast feeds with a new episode released in the last 3 days.
	public let feedsWithNewEpisodes3days: Int
	
	/// Podcast feeds with a new episode released in the last 10 days.
	public let feedsWithNewEpisodes10days: Int
	
	/// Podcast feeds with a new episode released in the last 30 days.
	public let feedsWithNewEpisodes30days: Int
	
	/// Podcast feeds with a new episode released in the last 90 days.
	public let feedsWithNewEpisodes90days: Int
	
	/// Podcast feeds with a value block
	public let feedsWithValueBlocks: Int
}