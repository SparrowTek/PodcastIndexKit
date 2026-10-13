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

    @Test("Episode array fixture decodes")
    func episodes() throws {
        let response = try JSONDecoder.podcastIndexDecoder.decode(EpisodeArrayResponse.self, from: fixture("episodeArrayResponse"))
        #expect((response.items?.count ?? 0) > 0)
        #expect(response.items?.first?.id != nil)
        #expect(response.items?.first?.datePublished != nil)
    }
}
