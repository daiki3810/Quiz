//
//  Translation.swift
//  Quiz
//

import SwiftData
import Foundation

@Model
final class Translation {
    @Attribute(.unique) var id: UUID
    var originalText: String
    var translatedText: String
    var sourceLang: String
    var targetLang: String
    var createdAt: Date
    
    init(originalText: String, translatedText: String, sourceLang: String, targetLang: String) {
        self.id = UUID()
        self.originalText = originalText
        self.translatedText = translatedText
        self.sourceLang = sourceLang
        self.targetLang = targetLang
        self.createdAt = Date()
    }
}
