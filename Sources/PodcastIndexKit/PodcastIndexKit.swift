import Foundation

public final class PodcastIndexKit: ObservableObject {
    public init() { }
    
    static public func setup(apiKey: String, apiSecret: String, userAgent: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        self.userAgent = userAgent
    }
    
    static var apiKey: String?
    static var apiSecret: String?
    static var userAgent: String?
    
    public lazy var searchService = SearchService()
}
