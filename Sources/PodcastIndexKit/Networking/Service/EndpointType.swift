import Foundation

protocol EndpointType: Sendable {
    var baseURL: URL { get async }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get async }
    var headers: HTTPHeaders? { get async }
}
