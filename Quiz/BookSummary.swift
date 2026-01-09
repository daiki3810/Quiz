//
//  BookSummary.swift
//  Quiz
//
//  Created by 宮本　大義 on 2026/01/09.
//

import SwiftData

@Model
final class BookSummary {
    @Attribute(.unique) var id: String
    var title: String
    var thumbnail: String?
    
    init(id: String, title: String, thumbnail: String? = nil) {
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
    }
}
