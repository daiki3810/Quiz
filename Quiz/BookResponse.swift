//
//  BookResponse.swift
//  Quiz
//
//  Created by 宮本　大義 on 2026/01/09.
//

struct TranslationResponse: Codable {
    var responseData: ResponseData
}

struct ResponseData: Codable {
    var translatedText: String
}

