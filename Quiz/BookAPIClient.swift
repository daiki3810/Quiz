//
//  BookAPIClient.swift
//  Quiz
//
//  Created by 宮本　大義 on 2026/01/09.
//

import SwiftUI

class TranslationAPIClient: ObservableObject {
    @Published var translation: TranslationResponse?
    private let apiClient = APIClient()
    
    func translate(text: String) {
        let isJapanese = text.range(of: "[\\p{Hiragana}\\p{Katakana}\\p{Han}]", options: .regularExpression) != nil
        let sourceLang = isJapanese ? "ja" : "en"
        let targetLang = isJapanese ? "en" : "ja"
        let urlString = "https://api.mymemory.translated.net/get?q=\(text)&langpair=\(sourceLang)|\(targetLang)"
        
        Task { @MainActor in
            self.translation = await apiClient.fetchData(from: urlString, responseType: TranslationResponse.self)
        }
    }
}

