//
//  MovieQuery.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/13/24.
//

struct MovieQuery: Hashable, EncodableData, Decodable {
    let query: String
}
