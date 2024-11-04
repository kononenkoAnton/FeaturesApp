//
//  Country.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//

import Foundation
// https://wino-feed.s3.amazonaws.com/movieFeed/movieFeedv2.json

struct MediaItemDTO: Codable {
    let type: String?
    let key: String
    let src: String?
}

struct MediaGroupDTO: Codable {
    let type: String
    let mediaItem: [MediaItemDTO]

    enum CodingKeys: String, CodingKey {
        case type
        case mediaItem = "media_item"
    }
}

struct ContentDTO: Codable {
    let type: String
    let src: String
}

struct ExtensionsDTO: Codable {
    let free: Bool?
    let playNextFeedURL: String?
}

struct EntryDTO: Codable {
    let id: String
    let title: String
    let summary: String
    let published: String?
    let content: ContentDTO
    let mediaGroup: [MediaGroupDTO]
    let extensions: ExtensionsDTO?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case summary
        case published
        case content
        case mediaGroup = "media_group"
        case extensions
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        summary = try container.decode(String.self, forKey: .summary)
        published = try container.decodeIfPresent(String.self, forKey: .published)
        content = try container.decode(ContentDTO.self, forKey: .content)
        mediaGroup = try container.decode([MediaGroupDTO].self, forKey: .mediaGroup)
        extensions = try container.decodeIfPresent(ExtensionsDTO.self, forKey: .extensions)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(summary, forKey: .summary)
        try container.encode(published, forKey: .published)
        try container.encode(content, forKey: .content)
        try container.encode(mediaGroup, forKey: .mediaGroup)
        try container.encodeIfPresent(extensions, forKey: .extensions)
    }

    init(id: String,
         title: String,
         summary: String,
         published: String?,
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

struct FeedDTO: Codable {
    let id: String
    let entry: [EntryDTO]
}
