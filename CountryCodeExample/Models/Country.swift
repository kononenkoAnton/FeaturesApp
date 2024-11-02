//
//  Country.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//

import Foundation

struct Language: Codable, Hashable {
    let code: String
    let name: String
}

struct Currency: Codable, Hashable {
    let code: String
    let name: String
    let symbol: String
}

struct Country: Codable, Hashable {
    let capital: String?
    let code: String
    let currency: Currency
    let flag: String
    let language: Language
    let name: String
    let region: String

    enum CodingKeys: CodingKey {
        case capital
        case code
        case currency
        case flag
        case language
        case name
        case region
    }

//    Example: get parametr for non existing type

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        capital = try container.decodeIfPresent(String.self, forKey: .capital)
        code = try container.decode(String.self, forKey: .code)
        currency = try container.decode(Currency.self, forKey: .currency)
        flag = try container.decode(String.self, forKey: .flag)
        language = try container.decode(Language.self, forKey: .language)
        name = try container.decode(String.self, forKey: .name)
        region = try container.decode(String.self, forKey: .region)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(capital, forKey: .capital)
        try container.encode(code, forKey: .code)
        try container.encode(currency, forKey: .currency)
        try container.encode(flag, forKey: .flag)
        try container.encode(language, forKey: .language)
        try container.encode(name, forKey: .name)
        try container.encode(region, forKey: .region)
    }
}
