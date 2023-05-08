//
//  Podcast.swift
//  
//
//  Created by Thomas Rademaker on 5/7/23.
//

import Foundation

public struct Podcast: Codable {
    public let id: Int
    public let title: String
    public let url: String
    public let originalUrl: String
    public let link: String
    public let description: String
    public let author: String
    public let ownerName: String
    public let image: String
    public let artwork: String
    public let lastUpdateTime: Date
    public let lastCrawlTime: Date
    public let lastParseTime: Date
    public let lastGoodHttpStatusTime: Date
    public let lastHttpStatus: Int
    public let contentType: String
    public let itunesId: Int?
    public let generator: String
    public let language: String
    public let type: Int
    public let dead: Int
    public let crawlErrors: Int
    public let parseErrors: Int
    public let categories: [String : String]?
    public let locked: Int
    public let explicit: Bool
    public let podcastGuid: String
    public let episodeCount: Int
    public let imageUrlHash: Double
    public let newestItemPubdate: Date
    public let itunesType: String?
    public let chash: String?
    public let value: PodcastValue?
    public let funding: PodcastFunding?
}

public struct PodcastValue: Codable {
    public let model: PodcastValueModel
    public let destinations: [PodcastValueDestination]
}

public struct PodcastValueModel: Codable {
    public let type: String
    public let method: String
    public let suggested: String
}

public struct PodcastValueDestination: Codable {
    public let name: String
    public let type: String
    public let address: String
    public let split: Int
    public let customKey: String?
    public let customValue: String?
    public let fee: Bool?
}

public struct PodcastFunding: Codable {
    public let url: String
    public let message: String
}
