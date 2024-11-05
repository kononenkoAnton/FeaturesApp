//
//  APIStorage.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import CoreFoundation

struct APIStorage {
    static func thumbnailImageEndpoint(path: String, width: CGFloat) -> Endpoint {
        Endpoint(path: path)
    }

    static func searchMoviesEndpoint(useCaseRequestDTO: SearchQueryUseCaseRequestDTO) throws -> Endpoint {
        Endpoint(path: "3/search/movie",
                 query: try useCaseRequestDTO.encodeDTO() ?? [:])
    }
}
