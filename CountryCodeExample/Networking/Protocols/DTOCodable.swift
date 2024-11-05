//
//  DTODecodable.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import Foundation

protocol DTODecodable: Decodable {
    associatedtype ModelDTO
    func decodeDTO(from data: Data) throws -> ModelDTO
}

// TODO: Check if usable or needs to be changed
protocol DTOEncodable: Encodable {
    associatedtype Dict
    func encodeDTO() throws -> Dict?
}

protocol DTOEncodableQuery: DTOEncodable {
    func encodeDTO() throws -> [String: String]?
}

extension DTOEncodableQuery {
    func encodeDTO() throws -> [String: String]? {
        let data = try JSONEncoder().encode(self)
        return try JSONSerialization.jsonObject(with: data) as? [String: String]
    }
}

protocol DTOCodable: DTODecodable & DTOEncodable {}
