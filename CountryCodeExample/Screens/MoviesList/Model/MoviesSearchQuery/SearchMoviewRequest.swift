//
//  SearchQueryUseCaseRequest.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/4/24.
//

struct SearchMoviewRequest: Hashable {
    let query: MovieQuery
    let page: Int
}

extension SearchMoviewRequest {
    var isQueryEmpty: Bool {
        query.query.isEmpty
    }
}

struct SearchMoviewRequestDTO: EncodableData,
    EncodableJSONSerialization,
    Decodable {
    let query: String
    let page: Int
}
