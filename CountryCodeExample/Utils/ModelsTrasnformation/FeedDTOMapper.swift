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
                 let content = Content(type: $0.content.type, src: $0.content.src)

                 var extensions: Extensions?
                 if let extensionsDTO = $0.extensions {
                     extensions = Extensions(free: extensionsDTO.free,
                                             playNextFeedURL: extensionsDTO.playNextFeedURL)
                 }

                 let mediaGroup = $0.mediaGroup.map { group in
                     let mediaItem = group.mediaItem.map { item in
                         MediaItem(type: item.type,
                                   key: item.key,
                                   src: item.src)
                     }

                     return MediaGroup(type: group.type, mediaItem: mediaItem)
                 }

                 return Entry(id: $0.id,
                              title: $0.title,
                              summary: $0.summary,
                              published: $0.published,
                              content: content,
                              mediaGroup: mediaGroup,
                              extensions: extensions)
             })
    }

    func mapToDTO(from modelDoman: Feed) -> FeedDTO {
        FeedDTO(id: modelDoman.id,
                entry: modelDoman.entry.map {
                    var extensions: ExtensionsDTO?
                    if let extensionsDTO = $0.extensions {
                        extensions = ExtensionsDTO(free: extensionsDTO.free,
                                                   playNextFeedURL: extensionsDTO.playNextFeedURL)
                    }

                    let mediaGroup = $0.mediaGroup.map { group in
                        let mediaItem = group.mediaItem.map { item in
                            MediaItemDTO(type: item.type,
                                         key: item.key,
                                         src: item.src)
                        }

                        return MediaGroupDTO(type: group.type, mediaItem: mediaItem)
                    }

                    return EntryDTO(id: $0.id,
                             title: $0.title,
                             summary: $0.summary,
                             published: $0.published,
                             content: ContentDTO(type: $0.content.type, src: $0.content.src),
                             mediaGroup: mediaGroup,
                             extensions: extensions)
                })
    }
}
