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

    /// The podcast whose feed is at `url`.
    ///
    /// Podcast Index matches the address as written, apart from taking `http`
    /// for `https` and overlooking a slash at the end: the host's case, a
    /// missing scheme and any difference in the query all miss. An address it
    /// does not hold is answered with a 400, which arrives here as
    /// ``NetworkError/statusCode(_:data:)``.
    public func podcast(byFeedUrl url: String) async throws -> Data {
        try await podcastsRouter.executeData(.byFeedURL(url: url, pretty: false))
    }

    public func trendingPodcasts(max: Int? = nil, lang: String? = nil, cat: String? = nil) async throws -> Data {
        try await podcastsRouter.executeData(.trending(max: max, since: nil, lang: lang, cat: cat, notcat: nil, pretty: false))
    }

    public func episodes(byFeedId id: Int, max: Int? = nil) async throws -> Data {
        try await episodesRouter.executeData(.byFeedID(id: String(id), since: nil, max: max, enclosure: nil, fulltext: false, pretty: false))
    }

    /// The most feeds one call to ``episodes(byFeedIds:since:max:)`` may name.
    public nonisolated static let maximumFeedsPerRequest = 200

    /// The most episodes one call to ``episodes(byFeedIds:since:max:)`` answers with.
    public nonisolated static let maximumEpisodesPerRequest = 1000

    /// What several feeds have published since a moment in time, in one
    /// answer, newest first.
    ///
    /// `since` is compared with an episode's publication date, not with when
    /// Podcast Index found it. `max` counts episodes across all the feeds,
    /// and an answer that comes back full is not the newest `max` of them:
    /// which episodes were left out cannot be told from it (measured
    /// 2026-11-24). Treat a full answer as "too many" and ask about fewer
    /// feeds at a time.
    ///
    /// A feed Podcast Index does not hold, or one with nothing new, is simply
    /// absent from the answer.
    ///
    /// - Parameters:
    ///   - ids: The feeds, at most ``maximumFeedsPerRequest``.
    ///   - since: The earliest publication date to include.
    ///   - max: How many episodes to return at most, up to
    ///     ``maximumEpisodesPerRequest``. Podcast Index answers with far
    ///     fewer when this is left out.
    public func episodes(byFeedIds ids: [Int], since: Date, max: Int? = nil) async throws -> Data {
        let list = ids.map(String.init).joined(separator: ",")
        return try await episodesRouter.executeData(.byFeedID(id: list, since: since, max: max, enclosure: nil, fulltext: false, pretty: false))
    }

    public func episodes(byFeedUrl url: String, max: Int? = nil) async throws -> Data {
        try await episodesRouter.executeData(.byFeedURL(url: url, since: nil, max: max, fulltext: false, pretty: false))
    }

    /// - Parameter fullText: Whether text fields such as the description come back
    ///   whole. Podcast Index cuts them to 100 words otherwise, wherever in the
    ///   text, or in its markup, the hundredth word happens to end.
    public func episode(byId id: Int, fullText: Bool = false) async throws -> Data {
        try await episodesRouter.executeData(.byID(id: String(id), fulltext: fullText, pretty: false))
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
