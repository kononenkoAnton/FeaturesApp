//
//  Models.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

struct MediaItem {
    let type: String?
    let key: String
    let src: String?
}

struct MediaGroup {
    let type: String
    let mediaItem: [MediaItem]

    enum CodingKeys: String, CodingKey {
        case type
        case mediaItem = "media_item"
    }
}

struct Content {
    let type: String
    let src: String
    
    init(type: String, src: String) {
        self.type = type
        self.src = src
    }
}

struct Extensions {
    let free: Bool?
    let playNextFeedURL: String?
    
    init(free: Bool?, playNextFeedURL: String?) {
        self.free = free
        self.playNextFeedURL = playNextFeedURL
    }
}

struct Entry {
    let id: String
    let title: String
    let summary: String
    let published: String?
    let content: Content
    let mediaGroup: [MediaGroup]
    let extensions: Extensions?

    init(id: String,
         title: String,
         summary: String,
         published: String?,
         content: Content,
         mediaGroup: [MediaGroup],
         extensions: Extensions?) {
        self.id = id
        self.title = title
        self.summary = summary
        self.published = published
        self.content = content
        self.mediaGroup = mediaGroup
        self.extensions = extensions
    }
}

struct Feed {
    let id: String
    let entry: [Entry]
}
