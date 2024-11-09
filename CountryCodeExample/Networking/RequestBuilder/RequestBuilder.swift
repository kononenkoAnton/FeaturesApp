//
//  RequestBuilder.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/9/24.
//

import Foundation

protocol RequestBuilder {
    var config: any APIConfigurable { get }
    func request(endpoint: any EndpointProtocol) throws -> URLRequest
}

struct DefaultRequestBuilder: RequestBuilder {
    func request(endpoint: any EndpointProtocol) throws -> URLRequest {
        try endpoint.request(config: config)
    }

    var config: any APIConfigurable

    init(config: any APIConfigurable) {
        self.config = config
    }
}
