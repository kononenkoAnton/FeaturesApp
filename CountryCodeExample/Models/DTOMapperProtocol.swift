//
//  DTOMapper.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

protocol DTOMapperProtocol {
    associatedtype ModelDTO
    associatedtype ModelDomain

    func mapToDomain(from modelDTO: ModelDTO) -> ModelDomain
    func mapToDTO(from modelDoman: ModelDomain)
}
