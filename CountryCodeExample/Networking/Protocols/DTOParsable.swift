//
//  DTODecodable.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import Foundation

protocol DTODecodable: Codable {
    associatedtype ModelDTO
    func decodeDTO(from data: Data) throws -> ModelDTO
}
