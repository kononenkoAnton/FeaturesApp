//
//  FeedMapper.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

class FeedDTOMapper: DTOMapperProtocol {
    func mapToDomain(from modelDTO: ModelDTO) -> ModelDomain {
        Feed(id: modelDTO.id,
             entry: modelDTO.entry.map {
                 Entry(id: $0.id,
                       title: $0.title,
                       summary: $0.summary,
                       published: $0.published,
                       content: $0.content,
                       mediaGroup: $0.mediaGroup,
                       extensions: $0.extensions)
             })
    }

    func mapToDTO(from modelDoman: Feed) -> FeedDTO {
        FeedDTO(id: modelDoman.id,
                entry: modelDoman.entry.map {
                    EntryDTO(id: $0.id,
                             title: $0.title,
                             summary: $0.summary,
                             published: $0.published,
                             content: $0.content,
                             mediaGroup: $0.mediaGroup,
                             extensions: $0.extensions)
                })
    }
}
