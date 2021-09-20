//
//  ResultsPresenter.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 19.09.21.
//

import QuizCore

struct ResultsPresenter {
    
    let questions: [Question<String>]
    let result: QuizResult<Question<String>, [String]>
    let correctAnswers: [Question<String>: [String]]
    
    var title: String {
        return "Result"
    }
    
    var summary: String {
        return "You go \(result.score)/\(result.answers.count) correct"
    }
    
    var presentableAnswers: [PresentableAnswer] {
        return questions.map { question in
            guard
                let userAnswer = result.answers[question],
                let correctAnswer = correctAnswers[question]
            else {
                fatalError("Couldn't find correct answer for question \(question)")
            }
            
            return presentableAnswer(
                question: question,
                userAnswer: userAnswer,
                correctAnswer: correctAnswer
            )
        }
    }
    
    private func presentableAnswer(
        question: Question<String>,
        userAnswer: [String],
        correctAnswer: [String]
    ) -> PresentableAnswer {
        switch question {
        case .singleAnswer(let text), .multipleAnswer(let text):
            return PresentableAnswer(
                question: text,
                correctAnswer: formattedAnswer(correctAnswer),
                wrongAnswer: formattedWrongAnswer(userAnswer, correctAnswer)
            )
        }
    }
    
    
    private func formattedAnswer(_ answer: [String]) -> String {
        return answer.joined(separator: ", ")
    }
    
    private func formattedWrongAnswer(
        _ userAnswer: [String],
        _ correctAnswer: [String]
    ) -> String? {
        return correctAnswer == userAnswer ? nil : formattedAnswer(userAnswer)
    }
    
}
