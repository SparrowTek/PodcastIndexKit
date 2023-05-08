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
    public let itunesId: Int
    public let generator: String
    public let language: String
    public let type: Int
    public let dead: Int
    public let crawlErrors: Int
    public let parseErrors: Int
    public let categories: [String : String]
    public let locked: Int
    public let explicit: Bool
    public let podcastGuid: String
    public let episodeCount: Int
    public let imageUrlHash: Double
    public let newestItemPubdate: Date
    
//    "id": 75075,
//          "title": "Batman University",
//          "url": "https://feeds.theincomparable.com/batmanuniversity",
//          "originalUrl": "https://feeds.theincomparable.com/batmanuniversity",
//          "link": "https://www.theincomparable.com/batmanuniversity/",
//          "description": "Batman University is a seasonal podcast about you know who. It began with an analysis of episodes of “Batman: The Animated Series” but has now expanded to cover other series, movies, and media. Your professor is Tony Sindelar.",
//          "author": "Tony Sindelar",
//          "ownerName": "",
//          "image": "https://www.theincomparable.com/imgs/logos/logo-batmanuniversity-3x.jpg",
//          "artwork": "https://www.theincomparable.com/imgs/logos/logo-batmanuniversity-3x.jpg",
//          "lastUpdateTime": 1682875710,
//          "lastCrawlTime": 1683440011,
//          "lastParseTime": 1683440045,
//          "lastGoodHttpStatusTime": 1683440011,
//          "lastHttpStatus": 200,
//          "contentType": "application/rss+xml",
//          "itunesId": 1441923632,
//          "generator": "",
//          "language": "en-us",
//          "type": 0,
//          "dead": 0,
//          "crawlErrors": 0,
//          "parseErrors": 0,
//          "categories": {
//            "104": "Tv",
//            "105": "Film",
//            "107": "Reviews"
//          },
//          "locked": 0,
//          "explicit": false,
//          "podcastGuid": "ac9907f2-a748-59eb-a799-88a9c8bfb9f5",
//          "episodeCount": 19,
//          "imageUrlHash": 1702747127,
//          "newestItemPubdate": 1546399813
}
