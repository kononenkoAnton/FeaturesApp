//
//  DefaultMoviesQueryReository.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/13/24.
//


protocol MoviesQueryRepository {
    func fetchQueries(limit: Int) throws -> [MovieQuery]
    func saveQuery(qery: MovieQuery) throws
}

class DefaultMoviesQueryReository {
    func fetchQueries(limit: Int) throws -> [MovieQuery] {
      return []
    }
    
    func saveQuery(qery: MovieQuery) throws {
        
    }
}
