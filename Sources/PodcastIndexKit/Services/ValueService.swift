import Get

public struct ValueService {
	private let apiClient = APIClient(configuration: configuration)
	private let basePath = "/value"
	
	/// This call returns the information for supporting the podcast via one of the "Value for Value" methods from the PodcastIndex ID.
	/// Additionally, the value block data can be accessed using static JSON files (updated every 15 minutes).
	///
	///- parameter id: (Required) The PodcastIndex Feed ID to search for.
	///- parameter pretty: If present, makes the output “pretty” to help with debugging.
	///- parameter shall not have a value
	///- returns: a `ValueResponse` object
	public func value(byFeedID id: String, pretty: Bool = false) async throws -> ValueResponse {
		var query: [(String, String?)]? = [("id", id)]
		appendNil(toQuery: &query, withKey: "pretty", forBool: pretty)
				
		return try await apiClient.send(Request(path: "\(basePath)/byfeedid", query: query)).value	
	}
	
	/// This call returns the information for supporting the podcast via one of the "Value for Value" methods from feed URL.
	/// Additionally, the value block data can be accessed using static JSON files (updated every 15 minutes).
	/// 
	///- parameter url: (Required) Podcast feed URL
	///- parameter pretty: If present, makes the output “pretty” to help with debugging.
	/// Parameter shall not have a value
	///- returns: a `ValueResponse` object
	public func value(byFeedURL url: String, pretty: Bool = false) async throws -> ValueResponse {
		var query: [(String, String?)]? = [("url", url)]
		appendNil(toQuery: &query, withKey: "pretty", forBool: pretty)
				
		return try await apiClient.send(Request(path: "\(basePath)/byfeedurl", query: query)).value	
	}
}

public struct ValueResponse: Codable {
	public let status: String
	
	// {
	// 	"status": "true",
	// 	"query": {
	// 		"id": "920666"
	// 	},
	// 	"value": {
	// 		"model": {
	// 			"type": "lightning",
	// 			"method": "keysend",
	// 			"suggested": "0.00000005000"
	// 		},
	// 		"destinations": [
	// 			{
	// 				"name": "Podcastindex.org",
	// 				"type": "node",
	// 				"address": "03ae9f91a0cb8ff43840e3c322c4c61f019d8c1c3cea15a25cfc425ac605e61a4a",
	// 				"split": 90
	// 			},
	// 			{
	// 				"name": "Dreb Scott (Chapters)",
	// 				"type": "node",
	// 				"address": "02453e4e93322d60219808c00c2e6d1f1c673420e95b5511a33c40cfb4df5e9148",
	// 				"split": 5
	// 			},
	// 			{
	// 				"name": "Sovereign Feeds",
	// 				"type": "node",
	// 				"address": "030a58b8653d32b99200a2334cfe913e51dc7d155aa0116c176657a4f1722677a3",
	// 				"split": 5,
	// 				"customKey": "696969",
	// 				"customValue": "eChoVKtO1KujpAA5HCoB",
	// 				"fee": true
	// 			},
	// 			{
	// 				"name": "BoostBot",
	// 				"type": "node",
	// 				"address": "03d55f4d4c870577e98ac56605a54c5ed20c8897e41197a068fd61bdb580efaa67",
	// 				"split": 1
	// 			},
	// 			{
	// 				"name": "Boostagram Monitor",
	// 				"type": "node",
	// 				"address": "038399372001f2741d58d6ec4846fccb78daa1a485e69e2eebc5aadba047d35956",
	// 				"split": 1
	// 			},
	// 			{
	// 				"name": "Fountain Boost Bot",
	// 				"type": "node",
	// 				"address": "0332d57355d673e217238ce3e4be8491aa6b2a13f95494133ee243e57df1653ace",
	// 				"split": 1,
	// 				"customKey": "112111100",
	// 				"customValue": "wal_GJWRnH1vp88Uf"
	// 			},
	// 			{
	// 				"name": "Saturn Test",
	// 				"type": "node",
	// 				"address": "030a58b8653d32b99200a2334cfe913e51dc7d155aa0116c176657a4f1722677a3",
	// 				"split": 1,
	// 				"customKey": "696969",
	// 				"customValue": "gq0Z8b1wEftMkFL4vj7E"
	// 			},
	// 			{
	// 				"name": "Stay Safe Sage",
	// 				"type": "node",
	// 				"address": "030a58b8653d32b99200a2334cfe913e51dc7d155aa0116c176657a4f1722677a3",
	// 				"split": 1,
	// 				"customKey": "696969",
	// 				"customValue": "t2vRy8BdZutknl3LYOSG"
	// 			}
	// 		]
	// 	},
	// 	"description": "Found."
	// }
}