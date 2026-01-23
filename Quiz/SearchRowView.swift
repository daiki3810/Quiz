//
//  SearchRowView.swift
//  Quiz
//
//  Created by 宮本　大義 on 2026/01/09.
//

import SwiftUI
import SwiftData

struct SearchRowView: View {
    @Environment(\.modelContext) private var modelContext
    @State var isSaved: Bool = false
    let originalText: String
    let translatedText: String
    let sourceLang: String
    let targetLang: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            HStack {
                Text(sourceLang.uppercased())
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(4)
                
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(targetLang.uppercased())
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(4)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("原文")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(originalText)
                    .font(.body)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 4) {
                Text("翻訳")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(translatedText)
                    .font(.body)
                    .fontWeight(.medium)
            }
            
            Spacer()
            
            Button(action: {
                guard !isSaved else { return }
                let translation = Translation(
                    originalText: originalText,
                    translatedText: translatedText,
                    sourceLang: sourceLang,
                    targetLang: targetLang
                )
                modelContext.insert(translation)
                isSaved = true
            }, label: {
                HStack {
                    Image(systemName: isSaved ? "checkmark.circle.fill" : "bookmark")
                    Text(isSaved ? "保存済み" : "保存する")
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSaved ? Color.gray : Color.blue)
                .cornerRadius(8)
            })
            .buttonStyle(PlainButtonStyle())
            .disabled(isSaved)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    SearchRowView(
        originalText: "Hello",
        translatedText: "こんにちは",
        sourceLang: "en",
        targetLang: "ja"
    )
}
