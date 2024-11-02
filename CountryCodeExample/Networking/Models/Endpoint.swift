//
//  Endpoint.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/1/24.
//

class Endpoint: EndpointProtocol {
    var path: String
    var headers: [String: String]
    var query: [String: String]
    var body: [String: String]

    init(path: String,
         headers: [String: String] = [:],
         query: [String: String] = [:],
         body: [String: String] = [:]) {
        self.path = path
        self.headers = headers
        self.query = query
        self.body = body
    }
}
