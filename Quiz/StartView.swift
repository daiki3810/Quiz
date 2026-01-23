import SwiftUI
import SwiftData

struct StartView: View {
    @Query(sort: \Translation.createdAt, order: .reverse) private var translations: [Translation]
    @State private var navigationPath = NavigationPath()
    @State private var score = 0
    @State private var totalQuestions = 0
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color(.background)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Text("単語クイズ")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(Color(.white))
                    
                    Text("保存された単語: \(translations.count)個")
                        .font(.title3)
                        .foregroundStyle(Color(.white).opacity(0.8))
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    if translations.count >= 3 {
                        Button {
                            navigationPath.append("quiz")
                        } label: {
                            Text("スタート")
                                .font(.system(size: 18, weight: .bold))
                                .padding(.vertical, 20)
                                .padding(.horizontal, 70)
                                .background(.white)
                                .foregroundStyle(Color(.background))
                                .clipShape(.rect(cornerRadius: 10))
                        }
                    } else {
                        VStack(spacing: 15) {
                            Text("クイズを開始するには")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("最低3つの単語を保存してください")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(.white.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "quiz" {
                    QuizView(score: $score, totalQuestions: $totalQuestions, navigationPath: $navigationPath)
                }
            }
        }
    }
}

#Preview {
    StartView()
        .modelContainer(for: Translation.self, inMemory: true)
}
