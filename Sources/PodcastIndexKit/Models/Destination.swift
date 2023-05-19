public struct Destination: Codable, Hashable, Sendable {
	/// Name for the destination
	public let name: String
	
	/// Address of node to receive payment
	public let address: String
	
	/// Type of destination
	/// Allowed: node
	public let `type`: DestinationType
	
	/// Share of payment the destination should receive
	public let split: Int
	
	/// Indicates if destination is included due to a fee being charged
	public let fee: Bool
	
	/// The name of a custom record key to send along with the payment.
	/// See the [podcast namespace spec](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#value) and [value specification](https://github.com/Podcastindex-org/podcast-namespace/blob/main/value/value.md) for more information.
	public let customKey: String
	
	/// A custom value to pass along with the payment. This is considered the value that belongs to the customKey.
	/// See the [podcast namespace spec](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#value) and [value specification](https://github.com/Podcastindex-org/podcast-namespace/blob/main/value/value.md) for more information.
	public let customValue: String
}

public enum DestinationType: String, Codable, Hashable, Sendable {
	case node
}