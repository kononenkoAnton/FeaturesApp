//
//  SearchQueryUseCaseRequest.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/4/24.
//

struct SearchQueryUseCaseRequest: EncodableData, EncodableJSONSerialization, Decodable, Hashable {
    let query: String
    let page: Int
}
