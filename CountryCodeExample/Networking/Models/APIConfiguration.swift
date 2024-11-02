//
//  APIConfiguration.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//
import Foundation

struct APIConfiguration: APIConfigurable {
    let baseURL: URL
    let headers: [String : String]
    let query: [String : String]
    
    init(baseURL: URL,
         headers: [String : String] = [:],
         query: [String : String] = [:]) {
        self.baseURL = baseURL
        self.headers = headers
        self.query = query
    }
}
