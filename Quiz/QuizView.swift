import SwiftUI

struct QuizView: View {
//    @Binding var currentScreen: Screen
    @Binding var score: Int
    @Binding var totalQuestions: Int
    
    // ここにクイズの問題と選択肢、正解を定義します
    let quizItems: [QuizItem] = [
        QuizItem(question: "iPhoneを開発している企業はどこ？", options: ["Google", "Apple", "Samsung"], correctAnswerIndex: 1),
        QuizItem(question: "日本で2番目に高い山は？", options: ["富士山", "北岳", "穂高岳"], correctAnswerIndex: 1),
        QuizItem(question: "第二次界大戦の時にドイツの総統となった人物の名前は？", options: ["ビスマルク", "ムッソリーニ", "ヒトラー"], correctAnswerIndex: 0),
        QuizItem(question: "第二次界大戦の時にイタリアの独裁者となった人物の名前は？", options: ["ビスマルク", "ムッソリーニ", "ヒトラー"], correctAnswerIndex: 1),
        QuizItem(question: "ビスマルクの名言は？", options: ["「現在の問題は演説や多数決によってではなく、鉄と血によってのみ解決される」", "「やってみせ、言って聞かせて、させてみせ、ほめてやらねば、人は動かじ」", "「是非に及ばず」"], correctAnswerIndex: 0),
    ]
    
    @State private var currentQuestionIndex = 0
    @State private var isCorrect: Bool = false
    @State private var isShowingFeedback = false
    
    var currentQuestion: QuizItem {
        quizItems[currentQuestionIndex]
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("Apple Quiz")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(.white))
                    .padding(.top, 20)
                
                Spacer()
                
                // Question Text
                Text(currentQuestion.question)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Color(.white))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(minHeight: 100, alignment: .center)
                
                Spacer()
                // Feedback Message Area
                Text(isCorrect ? "正解" : "不正解... 正解は「\(currentQuestion.options[currentQuestion.correctAnswerIndex])」")
                    .font(.headline)
                    .padding(10)
                    .background(.thinMaterial)
                    .foregroundStyle(Color(isCorrect ? .green : .red))
                    .clipShape(.rect(cornerRadius: 10))
                    .opacity(isShowingFeedback ? 1 : 0)
                
                Spacer()
                
                // Answer Options
                VStack(spacing: 16) {
                    ForEach(0..<currentQuestion.options.count, id: \.self) { index in
                        Button {
                            answerTapped(index)
                        } label: {
                            Text(currentQuestion.options[index])
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(Color(.background))
                                .frame(maxWidth: .infinity, minHeight: 70)
                                .background(.white)
                                .clipShape(.rect(cornerRadius: 10))
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            // QuizViewが表示された際に、問題総数をContentViewに伝える
            totalQuestions = quizItems.count
        }
    }
    // ボタンがタップされたときの処理
    func answerTapped(_ index: Int) {
        isShowingFeedback = true
        
        if index == currentQuestion.correctAnswerIndex {
            isCorrect = true
            score += 1
        } else {
            isCorrect = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            isShowingFeedback = false
            
            if currentQuestionIndex < quizItems.count - 1 {
                currentQuestionIndex += 1
                isShowingFeedback = false
            } else {
                // 全問終了
                // currentScreen = .result
            }
        }
    }
}

// MARK: - Preview
#Preview {
    @Previewable @State var currentScreen: Screen = .quiz
    @Previewable @State var score: Int = 0
    @Previewable @State var totalQuestions: Int = 5
    ZStack {
        Color(.background)
            .ignoresSafeArea()
        QuizView(
           // currentScreen: $currentScreen,
            score: $score,
            totalQuestions: $totalQuestions
        )
    }
}

