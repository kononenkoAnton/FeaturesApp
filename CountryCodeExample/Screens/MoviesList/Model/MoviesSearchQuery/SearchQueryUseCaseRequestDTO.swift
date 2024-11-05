//
//  SearchQueryUseCaseRequestDTO.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/4/24.
//

struct SearchQueryUseCaseRequestDTO: DTOEncodableQuery {
    let query: String
    let page: Int
}
