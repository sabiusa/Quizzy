//
//  ResultsPresenter.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 19.09.21.
//

import QuizCore

final class ResultsPresenter {
    
    typealias Answers = [(question: Question<String>, answer: [String])]
    typealias Scorer = ([[String]], [[String]]) -> Int
    
    private let userAnswers: Answers
    private let correctAnswers: Answers
    private let scorer: Scorer
    
    init(
        userAnswers: Answers,
        correctAnswers: Answers,
        scorer: @escaping Scorer
    ) {
        self.userAnswers = userAnswers
        self.correctAnswers = correctAnswers
        self.scorer = scorer
    }
    
    var title: String {
        return "Result"
    }
    
    var score: Int {
        return scorer(userAnswers.map(\.answer), correctAnswers.map(\.answer))
    }
    
    var summary: String {
        return "You go \(score)/\(userAnswers.count) correct"
    }
    
    var presentableAnswers: [PresentableAnswer] {
        return zip(userAnswers, correctAnswers).map { userAnswer, correctAnswer in
            return presentableAnswer(
                question: userAnswer.question,
                userAnswer: userAnswer.answer,
                correctAnswer: correctAnswer.answer
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
