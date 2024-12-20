//
//  FeedDTODecoder.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import Foundation

class MoviewSearchDTODecoder: DecodableData {
    func from(data: Data) throws -> MoviesSearchDTO {
        try JSONDecoder().decode(MoviesSearchDTO.self, from: data)
    }
}
