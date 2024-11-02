//
//  Country.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 10/30/24.
//

import Foundation
// https://wino-feed.s3.amazonaws.com/movieFeed/movieFeedv2.json

struct MediaItemDTO: Codable {
    let type: String
    let key: String
    let src: String
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
    let free: String
    let playNextFeedURL: String
}

struct EntryDTO: Codable {
    let id: String
    let title: String
    let summary: String
    let published: String
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
        published = try container.decode(String.self, forKey: .published)
        content = try container.decode(ContentDTO.self, forKey: .content)
        mediaGroup = try container.decode([MediaGroupDTO].self, forKey: .mediaGroup)
        extensions = try container.decodeIfPresent(ExtensionsDTO.self, forKey: .extensions)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.summary, forKey: .summary)
        try container.encode(self.published, forKey: .published)
        try container.encode(self.content, forKey: .content)
        try container.encode(self.mediaGroup, forKey: .mediaGroup)
        try container.encodeIfPresent(self.extensions, forKey: .extensions)
    }
}

struct FeedDTO: Codable {
    let entry: [EntryDTO]
}
