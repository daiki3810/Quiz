//
//  SearchView.swift
//  Quiz
//
//  Created by 宮本　大義 on 2026/01/04.
//

import SwiftUI

struct SearchView: View {
    @State private var inputText = ""
    @State private var lastTranslatedText = ""
    @StateObject private var apiClient = TranslationAPIClient()
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                // 入力エリア
                VStack(spacing: 12) {
                    TextField("日本語または英語を入力", text: $inputText, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...6)
                        .padding(.horizontal)
                    
                    Button(action: {
                        lastTranslatedText = inputText
                        apiClient.translate(text: inputText)
                    }) {
                        HStack {
                            Image(systemName: "globe")
                            Text("翻訳する")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(inputText.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(inputText.isEmpty)
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .background(Color(.systemGroupedBackground))
                
                // 翻訳結果エリア
                if let translation = apiClient.translation, !lastTranslatedText.isEmpty {
                    let isJapanese = lastTranslatedText.range(of: "[\\p{Hiragana}\\p{Katakana}\\p{Han}]", options: .regularExpression) != nil
                    let sourceLang = isJapanese ? "ja" : "en"
                    let targetLang = isJapanese ? "en" : "ja"
                    
                    List {
                        SearchRowView(
                            originalText: lastTranslatedText,
                            translatedText: translation.responseData.translatedText,
                            sourceLang: sourceLang,
                            targetLang: targetLang
                        )
                        .id("\(lastTranslatedText)-\(translation.responseData.translatedText)")
                    }
                    .listStyle(.plain)
                } else {
                    ContentUnavailableView(
                        "翻訳",
                        systemImage: "character.textbox",
                        description: Text("テキストを入力して翻訳ボタンを押してください")
                    )
                }
            }
            .navigationTitle("翻訳")
        }
    }
}

#Preview {
    SearchView()
}

