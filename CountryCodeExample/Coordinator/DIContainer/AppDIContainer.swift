//
//  AppDIContainer.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//

import Foundation

class AppDIContainer {
    lazy var applicationAPIConfig = ApplicationAPIConfig()

    lazy var networkConfig: APIConfigurable = {
        guard let url = URL(string: applicationAPIConfig.baseURL) else {
            fatalError("Can not create base api url")
        }
        
        return APIConfiguration(baseURL: url)
    }()
}
