//
//  Flow.swift
//  QuizCore
//
//  Created by Saba Khutsishvili on 15.09.21.
//

import Foundation

class Flow<Delegate: QuizDelegate> {
    
    typealias Question = Delegate.Question
    typealias Answer = Delegate.Answer
    
    private let delegate: Delegate
    private let questions: [Question]
    private var answers = [Question: Answer]()
    private let scoring: ([Question: Answer]) -> Int
    
    init(
        questions: [Question],
        router: Delegate,
        scoring: @escaping ([Question: Answer]) -> Int
    ) {
        self.questions = questions
        self.delegate = router
        self.scoring = scoring
    }
    
    func start() {
        delegateQuestionHandling(at: questions.startIndex)
    }
    
    func delegateQuestionHandling(at index: Int) {
        if index < questions.endIndex {
            let question = questions[index]
            delegate.handle(
                question: question,
                answerCallback: callback(for: question, at: index)
            )
        } else {
            delegate.handle(result: result())
        }
    }
    
    private func delegateQuestionHandling(after index: Int) {
        delegateQuestionHandling(at: questions.index(after: index))
    }
    
    private func callback(
        for question: Question,
        at index: Int
    ) -> ((Answer) -> Void) {
        return { [weak self] answer in
            self?.answers[question] = answer
            self?.delegateQuestionHandling(after: index)
        }
    }
    
    private func result() -> QuizResult<Question, Answer> {
        return QuizResult(answers: answers, score: scoring(answers))
    }
    
}

