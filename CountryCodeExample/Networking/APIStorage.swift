//
//  APIStorage.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import CoreFoundation

struct APIStorage {
    static func posterImageEndpoint(path: String,
                                    width: Int) -> Endpoint {
        let matchedSize = ImageSizeWidthMatcher(matchData: [92, 154, 185, 342, 500, 780]).matchSize(width: width)
        return Endpoint(path: "t/p/\(matchedSize)\(path)")
    }

    static func searchMoviesEndpoint(useCaseRequest: SearchQueryUseCaseRequest) throws -> Endpoint {
        Endpoint(path: "3/search/movie",
                 query: try useCaseRequest.toQueryParameters())
    }
}
