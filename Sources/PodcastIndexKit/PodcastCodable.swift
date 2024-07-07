import Foundation

protocol PodcastCodable: PodcastEncodable, PodcastDecodable, Sendable {}
protocol PodcastEncodable: Encodable, Sendable {}
protocol PodcastDecodable: Decodable, Sendable {}
