//
//  Episode.swift
//  
//
//  Created by Thomas Rademaker on 5/16/23.
//

import Foundation

/// /// All of the information about an Episode
public struct Episode: Codable {
    /// The internal PodcastIndex.org episode ID.
    public let id: Int
    
    /// Name of the feed
    public let title: String
    
    /// The channel-level link in the feed
    public let link: String
    
    /// The item-level description of the episode.
    /// Uses the longer of the possible fields in the feed: <description>, <itunes:summary> and <content:encoded>
    public let description: String
    
    /// The unique identifier for the episode
    public let guid: String
    
    /// The date and time the episode was published
    public let datePublished: Date
    
    /// The date and time the episode was published formatted as a human readable string.
    /// Note: uses the PodcastIndex server local time to do conversion.
    public let datePublishedPretty: String
    
    /// The time this episode was found in the feed
    public let dateCrawled: Date
    
    /// URL/link to the episode file
    public let enclosureUrl: String
    
    /// The Content-Type for the item specified by the enclosureUrl
    public let enclosureType: String

    /// The length of the item specified by the enclosureUrl in bytes
    public let enclosureLength: Int

    /// The time the livestream starts
    public let startTime: Int

    /// The time the livestream ends
    public let endTime: Int

    
    /// Status of the livestream
    /// Allowed: ended┃live
    public let status: LivestreamStatus

    /// Link TODO
    public let contentLink: String

    /// The estimated length of the item specified by the enclosureUrl in seconds
    public let duration: Int

    /// Is feed or episode marked as explicit
    /// 0: not marked explicit
    /// 1: marked explicit
    /// Allowed: 0┃1
    public let explicit: EpisodeExplicitStatus

    /// Episode number
    public let episode: Int

    /// The type of episode
    /// Allowed: full┃trailer┃bonus
    public let episodeType: EpisodeType

    /// Season number
    public let season: Int

    /// The item-level image for the episode
    public let image: String

    /// The iTunes ID of this feed if there is one, and we know what it is.
    public let feedItunesId: Int

    /// The channel-level image element.
    public let feedImage: String

    /// The internal PodcastIndex.org Feed ID.
    public let feedId: Int

    /// The channel-level language specification of the feed. Languages accord with the RSS Language Spec.
    public let feedLanguage: String

    /// At some point, we give up trying to process a feed and mark it as dead. This is usually after 1000 errors without a successful pull/parse cycle. Once the feed is marked dead, we only check it once per month.
    public let feedDead: Int

    /// The internal PodcastIndex.org Feed ID this feed duplicates
    public let feedDuplicateOf: Int

    /// Link to the JSON file containing the episode chapters
    public let chaptersUrl: String

    /// Link to the file containing the episode transcript
    /// Note: in most use cases, the transcripts value should be used instead
    public let transcriptUrl: String
}

public enum LivestreamStatus: String, Codable {
    case ended
    case live
}

public enum EpisodeExplicitStatus: Int, Codable {
    case notExplicit = 0
    case explicit = 1
}

public enum EpisodeType: String, Codable {
    case full
    case trailer
    case bonus
}
