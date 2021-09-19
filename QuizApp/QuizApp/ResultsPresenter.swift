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
        return result.answers.map { question, userAnswers in
            switch question {
            case .singleAnswer(let text):
                return PresentableAnswer(
                    question: text,
                    correctAnswer: correctAnswers[question]!.first!,
                    wrongAnswer: userAnswers.first!
                )
            case .multipleAnswer(let text):
                return PresentableAnswer(
                    question: text,
                    correctAnswer: "",
                    wrongAnswer: nil
                )
            }
        }
    }
    
}
