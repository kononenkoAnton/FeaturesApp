//
//  APIConfigurable.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//

import Foundation

protocol APIConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var query: [String: String] { get }
}

