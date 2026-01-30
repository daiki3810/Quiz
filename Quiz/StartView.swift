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
                        .padding(60)
                    
                    Spacer()
                    
                    if translations.count >= 3 {
                        Text("保存された単語: \(translations.count)個")
                            .font(.title3)
                            .foregroundStyle(Color(.white))
                            .padding(.top, 10)
                        
                        Spacer()
                        
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
                        VStack(spacing:15) {
                            Text("保存された単語: \(translations.count)個\nクイズを開始するには\n最低3つの単語を保存してくだい")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding()
                                .background(.mint.opacity(0.8))
                                .cornerRadius(10)
                                .multilineTextAlignment(.center)
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
