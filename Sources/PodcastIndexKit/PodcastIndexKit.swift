import Foundation
import SwiftData

@Observable
public final class PodcastIndexKit: Sendable {
    public init() { }
    
    static public func setup(apiKey: String, apiSecret: String, userAgent: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        self.userAgent = userAgent
    }
    
    static var apiKey: String?
    static var apiSecret: String?
    static var userAgent: String?
    
    public var searchService = SearchService()
    public var podcastsService = PodcastsService()
    public var episodesService = EpisodesService()
    public var recentService = RecentService()
    public var valueService = ValueService()
    public var statsService = StatsService()
    public var categoriesService = CategoriesService()
    public var hubService = HubService()
    public var appleReplacementService = AppleReplacementService()
}
