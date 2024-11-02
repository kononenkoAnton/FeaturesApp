//
//  JSONParsable.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import Foundation

protocol JSONParsable: Codable {
    associatedtype Model
    func parse(data: Data) throws -> Model
}
