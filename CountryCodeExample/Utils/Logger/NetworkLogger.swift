//
//  NetworkLogger.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//

import OSLog

protocol LoggerFactoryProtocol {
    static func createLogger(subsystem: String, category: String) -> Logger
}

// TODO: Think probably same problem where make not sense to create Protocol here
extension LoggerFactoryProtocol {
    static func createLogger(subsystem: String, category: String) -> Logger {
        return Logger(subsystem: subsystem,
                      category: category)
    }
}

struct LoggerFactory: LoggerFactoryProtocol {}

// Logger can not be mocked properlry because of privacy reasons
protocol NetworkLoggable {
    func log(request: URLRequest)
    func log(error: NetworkError)
    func log(data: Data, statusCode: Int)
}

class DefaultNetworkLogger: NetworkLoggable {
    let logger: Logger

    init(logger: Logger = LoggerFactory.createLogger(subsystem: Bundle.main.bundleIdentifier! + ".Networking",
                                                     category: "NetworkService")) {
        self.logger = logger
    }

    let generalMesage = "Network Error:"
    func log(request: URLRequest) {
        if let url = request.url {
            logger.debug("Request url: \(url.absoluteString)")
        }

        if let method = request.httpMethod {
            logger.debug("HTTPMethod: \(method)")
        }

        if let headers = request.allHTTPHeaderFields {
            logger.debug("Headers: \(headers)")
        }

        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            logger.debug("Body: \(bodyString)")
        }
    }

    func log(error: NetworkError) {
        logger.error("\(self.generalMesage) \(error.localizedDescription)")
    }

    func log(data: Data,
             statusCode: Int) {
        if let response = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            logger.debug("Response - statusCode: \(statusCode) data: \(response)")
        }
    }
}
