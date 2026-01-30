import SwiftUI
import SwiftData

struct QuizView: View {
    @Binding var score: Int
    @Binding var totalQuestions: Int
    @Binding var navigationPath: NavigationPath
    
    @Query(
        sort: \Translation.createdAt,
        order: .reverse
    ) private var translations: [Translation]
    
    @State private var quizItems: [QuizItem] = []
    @State private var currentQuestionIndex = 0
    @State private var isCorrect: Bool = false
    @State private var isShowingFeedback = false
    @State private var showResult = false
    
    var currentQuestion: QuizItem? {
        guard !quizItems.isEmpty && currentQuestionIndex < quizItems.count else {
            return nil
        }
        return quizItems[currentQuestionIndex]
    }
    
    //保存された翻訳データからクイズ問題を生成
    func generateQuizItems() {
        guard translations.count >= 3 else {
            quizItems = []
            return
        }
        
        var items: [QuizItem] = []
        let shuffledTranslations = translations.shuffled()
        
        for(
            index,
            translation
        ) in shuffledTranslations
            .prefix(
                min(
                    translations.count,
                    10
                )
            )
                .enumerated() {
            //日本語を問題文、英語を選択肢にする
            let question = translation.sourceLang == "ja" ? translation.originalText : translation.translatedText
            let correctAnswer = translation.sourceLang == "en" ? translation.originalText : translation.translatedText
            //不正解の選択肢を他の翻訳からランダムに選ぶ
            var wrongOptions : [String] = []
            var availableTranslations = shuffledTranslations.filter {
                $0.id != translation.id
            }
            
            while wrongOptions.count < 2 && !availableTranslations.isEmpty {
                if let wrongTranslation = availableTranslations.randomElement() {
                    let wrongAnswer = wrongTranslation.sourceLang == "en" ? wrongTranslation.originalText : wrongTranslation.translatedText
                    if !wrongOptions
                        .contains(
                            wrongAnswer
                        ) && wrongAnswer != correctAnswer {
                        wrongOptions
                            .append(
                                wrongAnswer
                            )
                    }
                    availableTranslations
                        .removeAll {
                            $0.id == wrongTranslation.id
                        }
                }
            }
            
            // 選択肢が3つ揃った場合のみ問題を追加
            if wrongOptions.count == 2 {
                var options = wrongOptions + [correctAnswer]
                options
                    .shuffle()
                
                let correctIndex = options.firstIndex(
                    of: correctAnswer
                ) ?? 0
                let quizItem = QuizItem(
                    question: question,
                    options: options,
                    correctAnswerIndex: correctIndex
                )
                items
                    .append(
                        quizItem
                    )
            }
        }
        
        quizItems = items
    }
    
    var body: some View {
        ZStack {
            Color(
                .background
            )
            .ignoresSafeArea()
            
            if quizItems.isEmpty {
                VStack(
                    spacing: 20
                ) {
                    Image(
                        systemName: "bookmark.slash"
                    )
                    .font(
                        .system(
                            size: 60
                        )
                    )
                    .foregroundColor(
                        .white.opacity(
                                0.6
                            )
                    )
                    
                    Text(
                        "保存された単語はありません"
                    )
                    .font(
                        .title2
                    )
                    .fontWeight(
                        .bold
                    )
                    .foregroundColor(
                        .white
                    )
                    Text(
                        "クイズを開始するには、\n最低3つの単語を保存してください"
                    )
                    .font(
                        .body
                    )
                    .foregroundColor(
                        .white.opacity(
                                0.8
                            )
                    )
                    .multilineTextAlignment(
                        .center
                    )
                }
                .padding()
            } else if let question = currentQuestion {
                VStack{
                    Text(
                        "単語クイズ"
                    )
                    .font(
                        .title
                    )
                    .fontWeight(
                        .bold
                    )
                    .foregroundStyle(
                        Color(
                            .white
                        )
                    )
                    .padding(
                        .top,
                        5
                    )
                    
                    Spacer()
                    
                    // Question Text
                    VStack(
                        spacing: 10
                    ) {
                        Text(
                            "この日本語の英訳は？"
                        )
                        .font(
                            .caption
                        )
                        .foregroundColor(
                            .white.opacity(
                                    0.7
                                )
                        )
                        
                        Text(
                            question.question
                        )
                        .font(
                            .system(
                                size: 28,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(
                            Color(
                                .white
                            )
                        )
                        .multilineTextAlignment(
                            .center
                        )
                        .padding(
                            .horizontal
                        )
                        .frame(
                            minHeight: 100,
                            alignment: .center
                        )
                    }
                    Spacer()
                    
                    // Feedback Message Area
                    if isShowingFeedback {
                        Text(
                            isCorrect ? "正解" : "不正解・・・　正解は「\(question.options[question.correctAnswerIndex])」"
                        )
                        .font(
                            .headline
                        )
                        .padding(
                            10
                        )
                        .background(
                            .thinMaterial
                        )
                        .foregroundStyle(
                            Color(
                                isCorrect ? .green : .red
                            )
                        )
                        .clipShape(
                            .rect(
                                cornerRadius: 10
                            )
                        )
                    }
                    
                    Spacer()
                    
                    //Answer Options
                    VStack(
                        spacing: 16
                    ) {
                        ForEach(
                            0..<question.options.count,
                            id: \.self
                        ) { Index in
                            Button {
                                answerTapped(
                                    Index
                                )
                            } label: {
                                Text(
                                    question
                                        .options[Index]
                                )
                                .font(
                                    .system(
                                        size: 18,
                                        weight: .bold
                                    )
                                )
                                .foregroundStyle(
                                    Color(
                                        .background
                                    )
                                )
                                .frame(
                                    maxWidth: .infinity,
                                    minHeight: 70
                                )
                                .background(
                                    .white
                                )
                                .clipShape(
                                    .rect(
                                        cornerRadius: 10
                                    )
                                )
                            }
                            .disabled(
                                isShowingFeedback
                            )
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            // クイズを新しくスタートする時にリセット
            currentQuestionIndex = 0
            isCorrect = false
            isShowingFeedback = false
            showResult = false
            score = 0
            
            generateQuizItems()
            totalQuestions = quizItems.count
        }
        onChange(
            of: translations
        ) {
            if currentQuestionIndex == 0 && !isShowingFeedback {
                generateQuizItems()
                totalQuestions = quizItems.count
            }
        }
        .navigationDestination(
            isPresented: $showResult
        ) {
            ResultView(
                score: $score,
                navigationPath: $navigationPath,
                totalQuestions: totalQuestions
            )
        }
        .navigationBarBackButtonHidden(
            true
        )
    }
    // ボタンがタップされたときの処理
    func answerTapped(
        _ index: Int
    ) {
        guard let question = currentQuestion else {
            return
        }
        
        isShowingFeedback = true
        
        if index == question.correctAnswerIndex {
            isCorrect = true
            score += 1
        } else {
            isCorrect = false
        }
        DispatchQueue.main
            .asyncAfter(
                deadline:
                        .now() + 2.0
            ){
                isShowingFeedback = false
                
                if currentQuestionIndex < quizItems.count - 1 {
                    currentQuestionIndex += 1
                } else {
                    // 全問終了 - 結果画面へ遷移
                    showResult = true
                }
            }
    }
}

// MARK: - Preview
#Preview {
    @Previewable @State var score: Int = 0
    @Previewable @State var totalQuestions: Int = 5
    @Previewable @State var navigationPath = NavigationPath()
    ZStack {
        Color(
            .background
        )
        .ignoresSafeArea()
        QuizView(
            score: $score,
            totalQuestions: $totalQuestions,
            navigationPath: $navigationPath
        )
    }
    .modelContainer(
        for: Translation.self,
        inMemory: true
    )
}

