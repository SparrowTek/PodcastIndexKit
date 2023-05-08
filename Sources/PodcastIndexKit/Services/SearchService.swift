//
//  SearchService.swift
//  
//
//  Created by Thomas Rademaker on 5/7/23.
//

import Get

public struct SearchService {
//https://api.podcastindex.org/api/1.0/search/byterm?q=bastiat
    private let apiClient = APIClient(configuration: configuration)
    private let basePath = "/search"
    
    public func byTerm(_ query: String) async throws -> SearchResult {
        try await apiClient.send(Request(path: "\(basePath)/byterm", query: [("q", query)])).value
    }
}
