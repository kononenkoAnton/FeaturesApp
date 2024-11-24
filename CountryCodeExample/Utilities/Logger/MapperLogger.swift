//
//  MapperLogger.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/4/24.
//

import OSLog

protocol SearchDTOMapperErrorLoggable {
    func logErrorDateFormat(movie: MovieDTO)
}

class SearchDTOMapperError: SearchDTOMapperErrorLoggable {
    let logger: Logger

    init(logger: Logger = LoggerFactory.createLogger(subsystem: Bundle.main.bundleIdentifier! + ".Mapper",
                                                     category: "FeedDTOMapper")) {
        self.logger = logger
    }

    func logErrorDateFormat(movie: MovieDTO) {
        logger.error("Can not format releaseDate to Date for date string: \(movie.releaseDate), item id: \(movie.id), title: \(movie.title)")
    }
}
