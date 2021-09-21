//
//  ResultsPresenter.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 19.09.21.
//

import QuizCore

final class ResultsPresenter {
    
    typealias Answers = [(question: Question<String>, answers: [String])]
    typealias Scorer = ([[String]], [[String]]) -> Int
    
    private let userAnswers: Answers
    private let correctAnswers: Answers
    private let scorer: Scorer
    
    init(
        questions: [Question<String>],
        result: QuizResult<Question<String>, [String]>,
        correctAnswers: [Question<String>: [String]]
    ) {
        self.userAnswers = questions.map { question in
            return (question, result.answers[question]!)
        }
        self.correctAnswers = questions.map { question in
            return (question, correctAnswers[question]!)
        }
        self.scorer = { _, _ in result.score }
    }
    
    var title: String {
        return "Result"
    }
    
    var score: Int {
        return scorer(userAnswers.map(\.answers), correctAnswers.map(\.answers))
    }
    
    var summary: String {
        return "You go \(score)/\(userAnswers.count) correct"
    }
    
    var presentableAnswers: [PresentableAnswer] {
        return zip(userAnswers, correctAnswers).map { userAnswer, correctAnswer in
            return presentableAnswer(
                question: userAnswer.question,
                userAnswer: userAnswer.answers,
                correctAnswer: correctAnswer.answers
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
