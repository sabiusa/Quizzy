//
//  ResultsView.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 22.09.21.
//

import SwiftUI

struct ResultsView: View {
    
    let title: String
    let summary: String
    let answers: [PresentableAnswer]
    let playAgain: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            HeaderView(title: title, subtitle: summary)
            
            List(answers, id: \.question) { model in
                ResultAnswerView(model: model)
            }
            
            Spacer()
            
            RoundedButton(title: "Play Again", action: playAgain)
                .padding()
        }
    }
    
}

struct ResultsView_Previews: PreviewProvider {
    
    static var previews: some View {
        ResultsTestView()
    }
    
    struct ResultsTestView: View {
        
        @State var playAgainCount = 0
        
        var body: some View {
            VStack {
                ResultsView(
                    title: "Result",
                    summary: "You got 2/5 correct",
                    answers: [
                        PresentableAnswer(
                            question: "What's the answer to question #1",
                            correctAnswer: "Correct answer",
                            wrongAnswer: "Wrong answer"
                        ),
                        PresentableAnswer(
                            question: "What's the answer to question #2",
                            correctAnswer: "Correct answer",
                            wrongAnswer: nil
                        ),
                        PresentableAnswer(
                            question: "What's the answer to question #3",
                            correctAnswer: "Correct answer",
                            wrongAnswer: "Wrong answer"
                        ),
                        PresentableAnswer(
                            question: "What's the answer to question #4",
                            correctAnswer: "Correct answer",
                            wrongAnswer: nil
                        ),
                        PresentableAnswer(
                            question: "What's the answer to question #5",
                            correctAnswer: "Correct answer",
                            wrongAnswer: "Wrong answer"
                        ),
                    ],
                    playAgain: { playAgainCount += 1 }
                )
                
                Text("Play again count: \(playAgainCount)")
            }
        }
        
    }
    
}
