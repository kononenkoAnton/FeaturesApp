//
//  DTODecodable.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import Foundation

protocol DecodableData {
    associatedtype ModelDTO
    func from(data: Data) throws -> ModelDTO
}

protocol DecodableJSONData: DecodableData {}

extension DecodableJSONData where ModelDTO: Decodable {
    func from(data: Data) throws -> ModelDTO {
        try JSONDecoder().decode(ModelDTO.self,
                                 from: data)
    }
}

protocol EncodableData: Encodable {
    func toData() throws -> Data
}

extension EncodableData {
    func toData() throws -> Data {
        try JSONEncoder().encode(self)
    }
}

protocol EncodableJSONSerialization: Encodable {
    func toDictionary() throws -> [String: Any]
}

extension EncodableJSONSerialization {
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let encodedDict = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw EncodingError.invalidValue(self, EncodingError.Context(codingPath: [],
                                                                         debugDescription: "Failed to convert encoded data to JSON object."))
        }

        return encodedDict
    }

    func toQueryParameters() throws -> [String: String] {
        let dictionary = try toDictionary()

        return dictionary.mapValues({ "\($0)" })
    }
}

// protocol DTOCodable: DTODecodable & DTOEncodable {}
