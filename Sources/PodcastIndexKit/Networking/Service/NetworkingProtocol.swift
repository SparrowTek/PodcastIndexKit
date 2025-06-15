@preconcurrency import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@PodcastActor
protocol Networking {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
extension URLSession: Networking { }
#else
import AsyncHTTPClient
import NIOHTTP1

class AsyncHTTPClientNetworking: Networking {
    private let client: HTTPClient
    
    init() {
        self.client = HTTPClient(eventLoopGroupProvider: .singleton)
    }
    
    deinit {
        try? client.syncShutdown()
    }
    
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        guard let url = request.url else {
            throw NetworkError.missingURL
        }
        
        var httpRequest = try HTTPClient.Request(url: url.absoluteString, method: NIOHTTP1.HTTPMethod(rawValue: request.httpMethod ?? "GET"))
        
        // Copy headers
        request.allHTTPHeaderFields?.forEach { key, value in
            httpRequest.headers.add(name: key, value: value)
        }
        
        // Copy body
        if let body = request.httpBody {
            httpRequest.body = .bytes(body)
        }
        
        let response = try await client.execute(request: httpRequest).get()
        
        // Convert response to URLResponse
        let urlResponse = HTTPURLResponse(
            url: url,
            statusCode: Int(response.status.code),
            httpVersion: "HTTP/1.1",
            headerFields: response.headers.reduce(into: [:]) { dict, header in
                dict[header.name] = header.value
            }
        )!
        
        // Get response body
        var bodyData = Data()
        if let body = response.body {
            var buffer = body
            while let chunk = buffer.readSlice(length: buffer.readableBytes) {
                bodyData.append(contentsOf: chunk.readableBytesView)
            }
        }
        
        return (bodyData, urlResponse)
    }
}
#endif
