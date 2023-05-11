//
//  PodcastArrayResult.swift
//  
//
//  Created by Thomas Rademaker on 5/7/23.
//

public struct PodcastArrayResult: Codable {
    public let status: String
    public let feeds: [Podcast]
    public let count: Int
    public let query: String
    public let description: String
}