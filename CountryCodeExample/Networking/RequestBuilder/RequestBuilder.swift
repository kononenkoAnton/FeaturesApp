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
    func url(endpoint: any EndpointProtocol) throws -> URL?
}

struct DefaultRequestBuilder: RequestBuilder {
    var config: any APIConfigurable

    init(config: any APIConfigurable) {
        self.config = config
    }

    func request(endpoint: any EndpointProtocol) throws -> URLRequest {
        try endpoint.request(config: config)
    }
    
    func url(endpoint: any EndpointProtocol) throws -> URL? {
        try endpoint.request(config: config).url
    }
}
