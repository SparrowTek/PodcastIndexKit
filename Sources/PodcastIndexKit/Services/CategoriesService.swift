import Get

public struct CategoriesService {
	private let apiClient = APIClient(configuration: configuration)
	private let basePath = "/categories"
	
	/// Return all the possible categories supported by the index.
	/// Example: [https://api.podcastindex.org/api/1.0/categories/list?pretty](https://api.podcastindex.org/api/1.0/categories/list?pretty)
	///
	///- parameter pretty: If present, makes the output “pretty” to help with debugging.
	/// Parameter shall not have a value
	///- returns: a `CategoriesResponse` object containing an array of `Category` objects
	public func list(pretty: Bool = false) async throws -> CategoriesResponse {
		var query: [(String, String?)]?
		appendNil(toQuery: &query, withKey: "pretty", forBool: pretty)
				
		return try await apiClient.send(Request(path: "\(basePath)/list", query: query)).value
	}
}
