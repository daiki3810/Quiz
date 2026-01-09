//
//  ListView.swift
//  Quiz
//
//  Created by 宮本　大義 on 2026/01/09.
//

import SwiftUI

struct ListView: View {
    @State private var favoriteBooks: [BookSummary] = []
    let columns = [GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if favoriteBooks.isEmpty {
                    Text("登録された本がありません")
                        .foregroundColor(.gray)
                        .padding()
                }
                
                LazyVGrid(columns: columns, spacing:0) {
                    ForEach(favoriteBooks, id: \.id) { book in
                        AsyncImage(url: URL(string: book.thumbnail ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                        } placeholder: {
                            ProgressView()
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .onAppear {
                favoriteBooks = SwiftDataManager().fetchAll()
            }
        }
    }
}

#Preview {
    ListView()
}
