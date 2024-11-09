//
//  AppDIContainer.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//

import Foundation

class AppDIContainer {
    lazy var applicationAPIConfig = ApplicationAPIConfig()
    let urlSessionCache: any NetworkResponseCacheable

    init(urlSessionCache: any NetworkResponseCacheable = URLRequestCache()) {
        self.urlSessionCache = urlSessionCache
    }

    private var baseURL: URL {
        guard let url = URL(string: applicationAPIConfig.baseURL) else {
            fatalError("Can not create base api url")
        }

        return url
    }

    private var imageBaseURL: URL {
        guard let url = URL(string: applicationAPIConfig.imageBaseURL) else {
            fatalError("Can not create base api url")
        }

        return url
    }

    private lazy var baseHeaders = {
        ["Authorization": "Bearer \(applicationAPIConfig.accessTokenAuth)",
         "Accept": "application/json"]
    }()

    lazy var apiRequestBuilder: RequestBuilder = {
        let apiConfiguration = APIConfiguration(baseURL: baseURL,
                                                headers: baseHeaders,
                                                query: ["language": NSLocale.preferredLanguages.first ?? "en"])
        
        return DefaultRequestBuilder(config: apiConfiguration)
    }()

    lazy var posterImageRequestBuilder: RequestBuilder = {
        let apiConfiguration = APIConfiguration(baseURL: baseURL)

        return DefaultRequestBuilder(config: apiConfiguration)
    }()
    
    // TODO: Possible should be repository
    func getMoviesListDIContainer() -> SearchMoviesScreenDIContainer {
        SearchMoviesScreenDIContainer(apiRequestBuilder: apiRequestBuilder,
                                      posterImageRequestBuilder: posterImageRequestBuilder)
    }
}



