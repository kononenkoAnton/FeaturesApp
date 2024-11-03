//
//  AppDIContainer.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//

import Foundation

class AppDIContainer {
    lazy var applicationAPIConfig = ApplicationAPIConfig()

    var baseURL: URL {
        guard let url = URL(string: applicationAPIConfig.baseURL) else {
            fatalError("Can not create base api url")
        }

        return url
    }

    lazy var apiNetworkService: NetworkServiceProtocol = {
        let apiConfiguration = APIConfiguration(baseURL: baseURL)

        return DefaultNetworkService(config: apiConfiguration)
    }()

    lazy var imageNetworkService: NetworkServiceProtocol = {
        let apiConfiguration = APIConfiguration(baseURL: baseURL)

        return DefaultNetworkService(config: apiConfiguration)
    }()

    // TODO: Possible should be repository
    func getDIContainer() -> MoviewsScreenDIContainer {
        MoviewsScreenDIContainer(apiNetworkService: apiNetworkService,
                                 imageNetworkService: imageNetworkService)
    }
}
