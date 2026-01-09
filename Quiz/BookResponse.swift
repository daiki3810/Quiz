//
//  BookResponse.swift
//  Quiz
//
//  Created by 宮本　大義 on 2026/01/09.
//

struct BookResponse: Codable {
    var totalItems: Int
    var items: [Item]
}

struct Item: Codable {
    var kind: String
    var id: String
    var selfLink: String
    var volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    var title: String?
    var authors: [String]?
    var description: String?
    var publisher: String?
    var imangeLinks: ImageLink?
}

struct ImageLink: Codable {
    var smallThumbnail: String?
    var thumbnail: String?
}

