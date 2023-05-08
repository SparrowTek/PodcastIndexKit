//
//  PodcastsResult.swift
//  
//
//  Created by Thomas Rademaker on 5/8/23.
//

public struct PodcastsResult: Codable {
    public let status: String
    public let feed: Podcast
    public let query: PodcastsResultsQuery
    public let description: String
}

public struct PodcastsResultsQuery: Codable {
    public let id: String?
    public let url: String?
    public let guid: String?
}
