import Foundation

/// Transcript information for an episode.
/// See the [podcast namespace spec](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#transcript) for more information.
public struct Transcript: Codable, Hashable, Sendable {
    /// The URL of the transcript file.
    public let url: String?
    
    /// The MIME type of the transcript file.
    public let type: String?
    
    /// The language of the transcript.
    /// Uses the [RSS Language Spec](https://www.rssboard.org/rss-language-codes).
    public let language: String?
    
    /// The type of transcript.
    /// Allowed: text┃html┃srt┃vtt
    public let transcriptType: TranscriptType?
    
    /// The URL of the transcript file.
    public let rel: String?
}

public enum TranscriptType: String, Codable, Hashable, Sendable {
    case text
    case html
    case srt
    case vtt
} 