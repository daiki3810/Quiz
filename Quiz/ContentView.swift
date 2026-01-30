import SwiftUI

// MARK: - Data Model
struct QuizItem {
    let question: String
    let options: [String] // 選択肢は3つ
    let correctAnswerIndex: Int // 正解の選択肢のインデックス（配列の要素番号）
}

// MARK: - App Screens Enum
enum Screen {
    //enumは限定された選択肢を扱う型で、画面の状態を管理するために使っているよ！
    case start
    case quiz
    case result
}

// MARK: - Main Content View
struct ContentView: View {
    @State private var currentScreen: Screen = .start
    @State private var score = 0
    @State private var totalQuestions: Int = 0
    
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            
            //ここで画面を切り替えてるよ〜
                TabView {
                    SearchView()
                        .tabItem {
                            Label("翻訳", systemImage: "magnifyingglass")
                        }
                    ListView()
                        .tabItem {
                            Label("リスト", systemImage: "folder")
                        }
                    StartView()
                        .tabItem {
                            Label("単語クイズ", systemImage: "questionmark")
                        }
                        
                }
            }
        }
    }

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modelContainer(for: Translation.self, inMemory: true)
    }
}
