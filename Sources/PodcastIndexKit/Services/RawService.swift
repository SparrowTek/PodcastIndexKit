import Foundation

/// Access to Podcast Index responses as the raw JSON bytes the API returned.
///
/// The typed services decode responses into models. A server that caches
/// responses wants the exact bytes instead, so it can store them and decode
/// later with ``JSONDecoder/podcastIndexDecoder``. Each method mirrors one of
/// the typed service calls and sends the same request.
@PodcastActor
public struct PodcastIndexRawService: Sendable {
    private let searchRouter: NetworkRouter<SearchAPI>
    private let podcastsRouter: NetworkRouter<PodcastsAPI>
    private let episodesRouter: NetworkRouter<EpisodesAPI>
    private let recentRouter: NetworkRouter<RecentAPI>
    private let categoriesRouter: NetworkRouter<CategoriesAPI>
    private let statsRouter: NetworkRouter<StatsAPI>

    public init() {
        let delegate = PodcastEnvironment.current.routerDelegate
        func make<Endpoint: EndpointType>(_: Endpoint.Type) -> NetworkRouter<Endpoint> {
            let router = NetworkRouter<Endpoint>(decoder: .podcastIndexDecoder)
            router.delegate = delegate
            return router
        }
        searchRouter = make(SearchAPI.self)
        podcastsRouter = make(PodcastsAPI.self)
        episodesRouter = make(EpisodesAPI.self)
        recentRouter = make(RecentAPI.self)
        categoriesRouter = make(CategoriesAPI.self)
        statsRouter = make(StatsAPI.self)
    }

    public func search(byTerm q: String, max: Int? = nil) async throws -> Data {
        try await searchRouter.executeData(.byTerm(q: q, val: nil, max: max, aponly: nil, clean: false, fulltext: false, pretty: false))
    }

    public func search(byTitle q: String, max: Int? = nil) async throws -> Data {
        try await searchRouter.executeData(.byTitle(q: q, val: nil, max: max, clean: false, fulltext: false, pretty: false, similar: false))
    }

    public func search(byPerson q: String, max: Int? = nil) async throws -> Data {
        try await searchRouter.executeData(.byPerson(q: q, max: max, fulltext: false, pretty: false))
    }

    public func podcast(byFeedId id: Int) async throws -> Data {
        try await podcastsRouter.executeData(.byFeedID(id: id, pretty: false))
    }

    public func podcast(byItunesId id: Int) async throws -> Data {
        try await podcastsRouter.executeData(.byItunesID(id: id, pretty: false))
    }

    public func trendingPodcasts(max: Int? = nil, lang: String? = nil, cat: String? = nil) async throws -> Data {
        try await podcastsRouter.executeData(.trending(max: max, since: nil, lang: lang, cat: cat, notcat: nil, pretty: false))
    }

    public func episodes(byFeedId id: Int, max: Int? = nil) async throws -> Data {
        try await episodesRouter.executeData(.byFeedID(id: String(id), since: nil, max: max, enclosure: nil, fulltext: false, pretty: false))
    }

    public func episodes(byFeedUrl url: String, max: Int? = nil) async throws -> Data {
        try await episodesRouter.executeData(.byFeedURL(url: url, since: nil, max: max, fulltext: false, pretty: false))
    }

    public func episode(byId id: Int) async throws -> Data {
        try await episodesRouter.executeData(.byID(id: String(id), fulltext: false, pretty: false))
    }

    public func recentEpisodes(max: Int? = nil) async throws -> Data {
        try await recentRouter.executeData(.episodes(max: max, excludeString: nil, before: nil, fulltext: false, pretty: false))
    }

    public func categories() async throws -> Data {
        try await categoriesRouter.executeData(.list(pretty: false))
    }

    public func stats() async throws -> Data {
        try await statsRouter.executeData(.current(pretty: false))
    }
}
