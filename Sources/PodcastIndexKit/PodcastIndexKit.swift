import Foundation

public final class PodcastIndexKit: ObservableObject {
    public init() { }
    
    static public func setup(apiKey: String, apiSecret: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
    }
    
    static public var apiKey: String?
    static public var apiSecret: String?
    
    public lazy var searchService = SearchService()
}
