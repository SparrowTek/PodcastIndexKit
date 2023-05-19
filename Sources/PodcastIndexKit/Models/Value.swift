public struct Value: Codable {
	/// Description of the method for providing "Value for Value" payments
	public let model: ValueModel
	
	/// List of destinations where "Value for Value" payments should be sent.
	/// ⮕ [ Destination for "Value for Value" payment. ]
	public let destinations: [Destination]
}

public enum ValueModelType: String, Codable {
	case lightning
	case hive
	case webmonetization
}

public struct ValueModel: Codable {
	/// Payment type
	/// Allowed: lightning┃hive┃webmonetization
	public let type: ValueModelType
	
	/// Method for sending payment
	public let method: String
	
	/// Suggested amount per second of playback to send. Unit is specific to the type.
	public let suggested: String
}

public struct ValueQuery: Codable {
	/// Value passed to request in the id field
	public let id: String?
	
	/// Value passed to request in the url field
	public let url: String?
}