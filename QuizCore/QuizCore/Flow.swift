//
//  Flow.swift
//  QuizCore
//
//  Created by Saba Khutsishvili on 15.09.21.
//

import Foundation

class Flow<R: QuizDelegate> {
    
    typealias Question = R.Question
    typealias Answer = R.Answer
    
    private let router: R
    private let questions: [Question]
    private var answers = [Question: Answer]()
    private let scoring: ([Question: Answer]) -> Int
    
    init(
        questions: [Question],
        router: R,
        scoring: @escaping ([Question: Answer]) -> Int
    ) {
        self.questions = questions
        self.router = router
        self.scoring = scoring
    }
    
    func start() {
        routeToQuestion(at: questions.startIndex)
    }
    
    func routeToQuestion(at index: Int) {
        if index < questions.endIndex {
            let question = questions[index]
            router.handle(
                question: question,
                answerCallback: callback(for: question, at: index)
            )
        } else {
            router.handle(result: result())
        }
    }
    
    private func routeToQuestion(after index: Int) {
        routeToQuestion(at: questions.index(after: index))
    }
    
    private func callback(
        for question: Question,
        at index: Int
    ) -> ((Answer) -> Void) {
        return { [weak self] answer in
            self?.answers[question] = answer
            self?.routeToQuestion(after: index)
        }
    }
    
    private func result() -> QuizResult<Question, Answer> {
        return QuizResult(answers: answers, score: scoring(answers))
    }
    
}

