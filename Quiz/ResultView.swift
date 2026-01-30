import SwiftUI

struct ResultView: View {
    @Binding var score: Int
    @Binding var navigationPath: NavigationPath
    
    let totalQuestions: Int
    
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            
            VStack {
                Text("Apple Quiz")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(.white))
                    .padding(.top, 20)
                
                Spacer()
                
                VStack {
                    Text("結果")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundStyle(Color(.white))
                    Text("\(score) / \(totalQuestions)問正解")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(Color(.white))
                }
                
                Spacer()
                
                Button {
                    score = 0 // スコアをリセット
                    navigationPath.removeLast(navigationPath.count) // スタート画面に戻る
                   // currentScreen = .start
                } label: {
                    Text("タイトルへ戻る")
                        .font(.system(size: 18, weight: .bold))
                        .padding(.vertical, 20)
                        .padding(.horizontal, 70)
                        .background(.white)
                        .foregroundStyle(Color(.background))
                        .clipShape(.rect(cornerRadius: 10))
                }
            }
            .padding()
        }
    }
}

#Preview {
    @Previewable @State var score: Int = 4
    @Previewable @State var navigationPath = NavigationPath()
    ZStack {
        Color(.background)
            .ignoresSafeArea()
        ResultView(
            score: $score,
            navigationPath: $navigationPath,
            totalQuestions: 5
        )
    }
}
