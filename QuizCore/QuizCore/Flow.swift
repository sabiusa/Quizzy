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
    private var newAnswers = [(Question, Answer)]()
    
    init(
        questions: [Question],
        delegate: Delegate
    ) {
        self.questions = questions
        self.delegate = delegate
    }
    
    func start() {
        delegateQuestionHandling(at: questions.startIndex)
    }
    
    func delegateQuestionHandling(at index: Int) {
        if index < questions.endIndex {
            let question = questions[index]
            delegate.answer(
                for: question,
                completion: answer(for: question, at: index)
            )
        } else {
            delegate.didCompleteQuiz(with: newAnswers)
        }
    }
    
    private func delegateQuestionHandling(after index: Int) {
        delegateQuestionHandling(at: questions.index(after: index))
    }
    
    private func answer(
        for question: Question,
        at index: Int
    ) -> ((Answer) -> Void) {
        return { [weak self] answer in
            self?.newAnswers.replaceOrInsert((question, answer), at: index)
            self?.delegateQuestionHandling(after: index)
        }
    }
    
}

private extension Array {
    
    mutating func replaceOrInsert(_ element: Element, at index: Index) {
        if index < count {
            remove(at: index)
        }
        insert(element, at: index)
    }
    
}
