import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Testing
@testable import PodcastIndexKit

/// A transport that records the request and returns canned bytes.
@PodcastActor
final class StubNetworking: PodcastIndexNetworking {
    var requests: [URLRequest] = []
    var responseData = Data("{}".utf8)
    var statusCode = 200

    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        requests.append(request)
        let url = request.url ?? URL(fileURLWithPath: "/")
        let response = try #require(HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil))
        return (responseData, response)
    }
}

private func fixture(_ name: String) throws -> Data {
    let url = try #require(Bundle.module.url(forResource: name, withExtension: "json", subdirectory: "Fixtures"))
    return try Data(contentsOf: url)
}

@Suite("Requests", .serialized)
struct RequestTests {
    @Test("The Authorization header is sha1(key + secret + time) with the configured User-Agent")
    func signing() throws {
        var request = URLRequest(url: try #require(URL(string: "https://api.podcastindex.org/api/1.0/categories/list")))
        PodcastIndexRouterDelegate.sign(&request, apiKey: "key", apiSecret: "secret", userAgent: "effem-appview/1.0", apiHeaderTime: "1700000000")
        #expect(request.value(forHTTPHeaderField: "X-Auth-Key") == "key")
        #expect(request.value(forHTTPHeaderField: "X-Auth-Date") == "1700000000")
        #expect(request.value(forHTTPHeaderField: "User-Agent") == "effem-appview/1.0")
        // printf 'keysecret1700000000' | shasum
        #expect(request.value(forHTTPHeaderField: "Authorization") == "abaf71c02050c31e4d4e6b08c1625173af0445ba")
    }

    @PodcastActor
    @Test("Requests fail with notConfigured before any network call when setup was skipped")
    func notConfigured() async throws {
        let stub = StubNetworking()
        PodcastEnvironment.current.setup(apiKey: "key", apiSecret: "secret", userAgent: "tests/1.0", networking: stub)
        PodcastEnvironment.current.apiKey = nil
        await #expect(throws: PodcastIndexError.notConfigured) {
            _ = try await PodcastIndexRawService().categories()
        }
        #expect(stub.requests.isEmpty)
    }

    @PodcastActor
    @Test("Search requests carry the query parameters and auth headers")
    func searchRequest() async throws {
        let stub = StubNetworking()
        PodcastEnvironment.current.setup(apiKey: "key", apiSecret: "secret", userAgent: "tests/1.0", networking: stub)
        stub.responseData = try fixture("podcastresponse")
        _ = try await PodcastIndexRawService().search(byTerm: "swift talk", max: 25)
        let request = try #require(stub.requests.first)
        let url = try #require(request.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        #expect(components.path == "/api/1.0/search/byterm")
        #expect(components.queryItems?.contains(URLQueryItem(name: "q", value: "swift talk")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "max", value: "25")) == true)
        #expect(request.value(forHTTPHeaderField: "X-Auth-Key") == "key")
        #expect(request.value(forHTTPHeaderField: "User-Agent") == "tests/1.0")
    }

    @PodcastActor
    @Test("A single episode is asked for with its full text only on request")
    func episodeFullText() async throws {
        let stub = StubNetworking()
        PodcastEnvironment.current.setup(apiKey: "key", apiSecret: "secret", userAgent: "tests/1.0", networking: stub)

        _ = try await PodcastIndexRawService().episode(byId: 16795090)
        _ = try await PodcastIndexRawService().episode(byId: 16795090, fullText: true)

        let queries = try stub.requests.map { request in
            let url = try #require(request.url)
            return try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        }
        #expect(queries.count == 2)
        #expect(queries.allSatisfy { $0.path == "/api/1.0/episodes/byid" })
        #expect(queries.allSatisfy { $0.queryItems?.contains(URLQueryItem(name: "id", value: "16795090")) == true })
        #expect(queries.first?.queryItems?.contains { $0.name == "fulltext" } == false)
        #expect(queries.last?.queryItems?.contains { $0.name == "fulltext" } == true)
    }

    @PodcastActor
    @Test("A podcast is asked for by the address of its feed, with the address intact")
    func podcastByFeedURL() async throws {
        let stub = StubNetworking()
        PodcastEnvironment.current.setup(apiKey: "key", apiSecret: "secret", userAgent: "tests/1.0", networking: stub)
        let address = "https://feeds.example.com/show+extra?id=1&format=rss#latest"

        _ = try await PodcastIndexRawService().podcast(byFeedUrl: address)

        let url = try #require(stub.requests.first?.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        #expect(components.path == "/api/1.0/podcasts/byfeedurl")
        #expect(components.queryItems == [URLQueryItem(name: "url", value: address)])
        // Nothing of the address may be left to act on the request itself.
        #expect(components.fragment == nil)
    }

    @PodcastActor
    @Test("A plus sign is escaped, because Podcast Index reads a bare one as a space")
    func plusSign() async throws {
        let stub = StubNetworking()
        PodcastEnvironment.current.setup(apiKey: "key", apiSecret: "secret", userAgent: "tests/1.0", networking: stub)

        _ = try await PodcastIndexRawService().search(byTerm: "c++ & rust", max: 5)
        _ = try await PodcastIndexRawService().episode(byId: 7, fullText: true)

        let queries = try stub.requests.map { request in
            let url = try #require(request.url)
            return try #require(URLComponents(url: url, resolvingAgainstBaseURL: false)?.percentEncodedQuery)
        }
        #expect(queries.first == "q=c%2B%2B%20%26%20rust&max=5")
        // A parameter without a value is still just its name.
        #expect(queries.last == "id=7&fulltext")
    }

    @PodcastActor
    @Test("Several feeds are asked about in one request, with the moment as a Unix timestamp")
    func episodesOfSeveralFeeds() async throws {
        let stub = StubNetworking()
        PodcastEnvironment.current.setup(apiKey: "key", apiSecret: "secret", userAgent: "tests/1.0", networking: stub)
        let since = Date(timeIntervalSince1970: 1_795_000_000.75)

        _ = try await PodcastIndexRawService().episodes(byFeedIds: [75075, 920666, 41504], since: since, max: 1000)

        let url = try #require(stub.requests.first?.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        #expect(components.path == "/api/1.0/episodes/byfeedid")
        #expect(components.queryItems == [
            URLQueryItem(name: "id", value: "75075,920666,41504"),
            URLQueryItem(name: "max", value: "1000"),
            URLQueryItem(name: "since", value: "1795000000"),
        ])
    }

    @PodcastActor
    @Test("A typed call sends a date as a Unix timestamp too")
    func dateParameter() async throws {
        let stub = StubNetworking()
        PodcastEnvironment.current.setup(apiKey: "key", apiSecret: "secret", userAgent: "tests/1.0", networking: stub)
        stub.responseData = try fixture("episodeArrayResponse")

        _ = try await EpisodesService().episodes(byFeedID: "75075", since: Date(timeIntervalSince1970: 1_700_000_000))

        let url = try #require(stub.requests.first?.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        #expect(components.queryItems?.contains(URLQueryItem(name: "since", value: "1700000000")) == true)
    }

    @PodcastActor
    @Test("Typed services decode through the same transport")
    func typedService() async throws {
        let stub = StubNetworking()
        PodcastEnvironment.current.setup(apiKey: "key", apiSecret: "secret", userAgent: "tests/1.0", networking: stub)
        stub.responseData = try fixture("categories")
        let response = try await CategoriesService().list()
        #expect(response.feeds?.first?.name == "Arts")
        #expect(stub.requests.first?.url?.path == "/api/1.0/categories/list")
    }

    @PodcastActor
    @Test("Non-2xx responses surface as statusCode errors with the body")
    func errorStatus() async throws {
        let stub = StubNetworking()
        PodcastEnvironment.current.setup(apiKey: "key", apiSecret: "secret", userAgent: "tests/1.0", networking: stub)
        stub.statusCode = 401
        stub.responseData = Data("denied".utf8)
        do {
            _ = try await PodcastIndexRawService().stats()
            Issue.record("expected an error")
        } catch NetworkError.statusCode(let code, let data) {
            #expect(code == .unauthorized)
            #expect(String(decoding: data, as: UTF8.self) == "denied")
        }
    }
}

@Suite("Decoding")
struct DecodingTests {
    @Test("Category list fixture decodes")
    func categories() throws {
        let response = try JSONDecoder.podcastIndexDecoder.decode(CategoriesResponse.self, from: fixture("categories"))
        #expect(response.status)
        #expect((response.feeds?.count ?? 0) > 50)
        #expect(response.feeds?.first?.name == "Arts")
    }

    @Test("Podcast fixture decodes with dates as Unix timestamps")
    func podcast() throws {
        let response = try JSONDecoder.podcastIndexDecoder.decode(PodcastResponse.self, from: fixture("podcastresponse"))
        let feed = try #require(response.feed)
        #expect(feed.id != nil)
        #expect(feed.title?.isEmpty == false)
        #expect(feed.lastUpdateTime != nil)
    }

    @Test("A lookup that found nothing decodes as nothing found", arguments: [
        #"{"status":"true","query":{"id":"999999999"},"feed":[],"description":"No feeds match this id."}"#,
        #"{"status":"true","query":{"url":"https://example.com/feed.xml"},"feed":[],"description":"No feeds match this url."}"#,
        #"{"status":"true","query":{"id":"1"},"feed":null,"description":"No feeds match this id."}"#,
        #"{"status":"false","description":"Feed url not found."}"#,
    ])
    func podcastNotFound(json: String) throws {
        let response = try JSONDecoder.podcastIndexDecoder.decode(PodcastResponse.self, from: Data(json.utf8))
        #expect(response.feed == nil)
    }

    @Test("A feed that is not a podcast object is still refused")
    func podcastMalformed() {
        let json = #"{"status":"true","feed":[{"id":1}],"description":"Found matching feed."}"#
        #expect(throws: DecodingError.self) {
            try JSONDecoder.podcastIndexDecoder.decode(PodcastResponse.self, from: Data(json.utf8))
        }
    }

    @Test("The echoed ID is read whether it comes back as text or as a number")
    func echoedID() throws {
        let byFeedID = #"{"status":"true","query":{"id":"551334"},"feed":{"id":551334,"title":"Planet Money"},"description":"Found matching feed."}"#
        let byItunesID = #"{"status":"true","query":{"id":290783428},"feed":{"id":551334,"title":"Planet Money"},"description":"Found matching feed."}"#

        let text = try JSONDecoder.podcastIndexDecoder.decode(PodcastResponse.self, from: Data(byFeedID.utf8))
        let number = try JSONDecoder.podcastIndexDecoder.decode(PodcastResponse.self, from: Data(byItunesID.utf8))

        #expect(text.query?.id == "551334")
        #expect(number.query?.id == "290783428")
        #expect(text.feed?.title == "Planet Money")
        #expect(number.feed?.id == 551334)
    }

    @Test("An episode lookup that found nothing decodes as nothing found")
    func episodeNotFound() throws {
        let json = #"{"status":"true","episode":[],"count":0,"id":"99999999999","description":"Episode not found."}"#
        let response = try JSONDecoder.podcastIndexDecoder.decode(EpisodeResponse.self, from: Data(json.utf8))
        #expect(response.episode == nil)
        #expect(response.id == "99999999999")
    }

    @Test("An episode that was found still decodes")
    func episodeFound() throws {
        let json = #"{"status":"true","id":"16795090","episode":{"id":16795090,"title":"Episode","feedId":75075},"description":"Found matching episodes."}"#
        let response = try JSONDecoder.podcastIndexDecoder.decode(EpisodeResponse.self, from: Data(json.utf8))
        #expect(response.episode?.id == 16795090)
        #expect(response.episode?.feedId == 75075)
    }

    @Test("Episode array fixture decodes")
    func episodes() throws {
        let response = try JSONDecoder.podcastIndexDecoder.decode(EpisodeArrayResponse.self, from: fixture("episodeArrayResponse"))
        #expect((response.items?.count ?? 0) > 0)
        #expect(response.items?.first?.id != nil)
        #expect(response.items?.first?.datePublished != nil)
    }
}
