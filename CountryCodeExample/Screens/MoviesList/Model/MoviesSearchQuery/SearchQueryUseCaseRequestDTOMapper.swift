//
//  SearchQueryUseCaseRequestDTOMapper.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/4/24.
//


class SearchQueryUseCaseRequestDTOMapper: DTOMapperProtocol {
    func mapToDomain(from modelDTO: SearchQueryUseCaseRequestDTO) -> SearchQueryUseCaseRequest {
        SearchQueryUseCaseRequest(query: modelDTO.query, page: modelDTO.page)
    }
    
    func mapToDTO(from modelDoman: SearchQueryUseCaseRequest) -> SearchQueryUseCaseRequestDTO {
        SearchQueryUseCaseRequestDTO(query: modelDoman.query, page: modelDoman.page)
    }
}
