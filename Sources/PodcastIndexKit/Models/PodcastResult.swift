//
//  PodcastResult.swift
//  
//
//  Created by Thomas Rademaker on 5/8/23.
//

public struct PodcastResult: Codable {
    public let status: String
    public let feed: Podcast
    public let query: PodcastResultsQuery
    public let description: String
}

public struct PodcastResultsQuery: Codable {
    public let id: String?
    public let url: String?
    public let guid: String?
}
