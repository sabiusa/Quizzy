//
//  ResultAnswerView.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 22.09.21.
//

import SwiftUI

struct ResultAnswerView: View {
    
    let model: PresentableAnswer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            Text(model.question)
                .font(.title)
            
            Text(model.correctAnswer)
                .font(.body)
                .foregroundColor(.green)
            
            if let wrongAnswer = model.wrongAnswer {
                Text(wrongAnswer)
                    .font(.body)
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical)
    }
}

struct ResultAnswerView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ResultAnswerView(model: PresentableAnswer(
                question: "What's the answer to question #4",
                correctAnswer: "Correct answer",
                wrongAnswer: nil
            ))
            .previewLayout(.sizeThatFits)
            
            ResultAnswerView(model: PresentableAnswer(
                question: "What's the answer to question #5",
                correctAnswer: "Correct answer",
                wrongAnswer: "Wrong answer"
            ))
            .previewLayout(.sizeThatFits)
        }
    }
    
}
