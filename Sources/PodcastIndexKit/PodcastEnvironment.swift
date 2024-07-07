
@PodcastActor
class PodcastEnvironment {
    static var current: PodcastEnvironment = .init()
    
    var appleReplacementBaseURL = "https://api.podcastindex.org"
    var indexURL = "https://api.podcastindex.org/api/1.0"
    
    var apiKey: String?
    var apiSecret: String?
    var userAgent: String?
    let routerDelegate = PodcastIndexRouterDelegate()
    
    private init() {}
    
    func setup(apiKey: String, apiSecret: String, userAgent: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        self.userAgent = userAgent
    }
}

