//
//  FeedDTODecoder.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import Foundation

class FeedDTODecoder: DTODecodable {
    func decodeDTO(from data: Data) throws -> MoviesSearchResultDTO {
        try JSONDecoder().decode(MoviesSearchResultDTO.self, from: data)
    }
}
