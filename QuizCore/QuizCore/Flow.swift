//
//  Flow.swift
//  QuizCore
//
//  Created by Saba Khutsishvili on 15.09.21.
//

import Foundation

class Flow<Question, Answer, R: Router>
where R.Question == Question,
      R.Answer == Answer {
    
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
        if let firstQuestion = questions.first {
            router.route(
                to: firstQuestion,
                answerCallback: nextCallback(from: firstQuestion)
            )
        } else {
            router.route(to: result())
        }
    }
    
    private func nextCallback(from question: Question) -> ((Answer) -> Void) {
        return { [weak self] answer in
            self?.routeNext(question, answer)
        }
    }
    
    private func routeNext(_ question: Question, _ answer: Answer) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            answers[question] = answer
            let nextQuestionIndex = currentQuestionIndex + 1
            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                router.route(
                    to: nextQuestion,
                    answerCallback: nextCallback(from: nextQuestion)
                )
            } else {
                router.route(to: result())
            }
        }
    }
    
    private func result() -> QuizResult<Question, Answer> {
        return QuizResult(answers: answers, score: scoring(answers))
    }
    
}

