//
//  APIStorage.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import CoreFoundation

struct APIStorage {
    struct MoviesScreen {
        static func thumbnailImageEndpoint(path: String, width: CGFloat) -> Endpoint {
            // TODO: make with effective
            Endpoint(path: path)
        }

        static func moviesListEndpoint(path: String) -> Endpoint {
            Endpoint(path: path)
        }
    }
}
