//
//  ResultsPresenter.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 19.09.21.
//

import QuizCore

struct ResultsPresenter {
    
    let result: QuizResult<Question<String>, [String]>
    let correctAnswers: [Question<String>: [String]]
    
    var summary: String {
        return "You go \(result.score)/\(result.answers.count) correct"
    }
    
    var presentableAnswers: [PresentableAnswer] {
        return result.answers.map { question, userAnswer in
            
            let correctAnswer = correctAnswers[question]!
            let wrongAnswer = correctAnswer == userAnswer
                ? nil
                : userAnswer.joined(separator: ", ")
            
            switch question {
            case .singleAnswer(let text), .multipleAnswer(let text):
                return PresentableAnswer(
                    question: text,
                    correctAnswer: correctAnswer.joined(separator: ", "),
                    wrongAnswer: wrongAnswer
                )
            }
        }
    }
    
}
