//
//  Models.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

struct MediaItem {
    let type: String
    let key: String
    let src: String
}

struct MediaGroup {
    let type: String
    let mediaItem: [MediaItemDTO]

    enum CodingKeys: String, CodingKey {
        case type
        case mediaItem = "media_item"
    }
}

struct Content {
    let type: String
    let src: String
}

struct Extensions {
    let free: String
    let playNextFeedURL: String
}

struct Entry {
    let id: String
    let title: String
    let summary: String
    let published: String
    let content: ContentDTO
    let mediaGroup: [MediaGroupDTO]
    let extensions: ExtensionsDTO?

    init(id: String,
         title: String,
         summary: String,
         published: String,
         content: ContentDTO,
         mediaGroup: [MediaGroupDTO],
         extensions: ExtensionsDTO?) {
        self.id = id
        self.title = title
        self.summary = summary
        self.published = published
        self.content = content
        self.mediaGroup = mediaGroup
        self.extensions = extensions
    }
}
