//
//  ListView.swift
//  Quiz
//
//  Created by 宮本　大義 on 2026/01/09.
//

import SwiftUI

struct ListView: View {
    @State private var savedTranslations: [Translation] = []
    
    var body: some View {
        NavigationStack {
            List {
                if savedTranslations.isEmpty {
                    ContentUnavailableView(
                        "保存された翻訳がありません",
                        systemImage: "bookmark.slash",
                        description: Text("翻訳を保存すると、ここに表示されます")
                    )
                } else {
                    ForEach(savedTranslations.reversed()) { translation in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(translation.sourceLang.uppercased())
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(4)
                                
                                Image(systemName: "arrow.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text(translation.targetLang.uppercased())
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.green.opacity(0.2))
                                    .cornerRadius(4)
                                
                                Spacer()
                                
                                Text(translation.createdAt, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("🇯🇵 日本語")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(translation.sourceLang == "ja" ? translation.originalText : translation.translatedText)
                                    .font(.body)
                            }
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("🇬🇧 英語")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(translation.sourceLang == "en" ? translation.originalText : translation.translatedText)
                                    .font(.body)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .onDelete(perform: deleteTranslations)
                }
            }
            .navigationTitle("保存済み")
            .toolbar {
                if !savedTranslations.isEmpty {
                    EditButton()
                }
            }
            .onAppear {
                savedTranslations = SwiftDataManager().fetchAll()
            }
        }
    }
    
    private func deleteTranslations(at offsets: IndexSet) {
        let reversedTranslations = savedTranslations.reversed()
        for index in offsets {
            let translation = Array(reversedTranslations)[index]
            SwiftDataManager().deleteItem(data: translation)
        }
        savedTranslations = SwiftDataManager().fetchAll()
    }
}

#Preview {
    ListView()
}
