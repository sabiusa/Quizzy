//
//  Flow.swift
//  QuizCore
//
//  Created by Saba Khutsishvili on 15.09.21.
//

import Foundation

protocol Router {
    typealias AnswerCallback = (String) -> Void
    
    func route(
        to question: String,
        answerCallback: @escaping AnswerCallback
    )
    
    func route(to result: [String: String])
}

class Flow {
    
    private let router: Router
    private let questions: [String]
    private var result = [String: String]()
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.route(
                to: firstQuestion,
                answerCallback: routeNext(from: firstQuestion)
            )
        } else {
            router.route(to: result)
        }
    }
    
    private func routeNext(from question: String) -> Router.AnswerCallback {
        return { [weak self] answer in
            guard let self = self else { return }
            
            self.preformRouteNext(from: question, answer: answer)
        }
    }
    
    private func preformRouteNext(from question: String, answer: String) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            result[question] = answer
            let nextQuestionIndex = currentQuestionIndex + 1
            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                router.route(
                    to: nextQuestion,
                    answerCallback: routeNext(from: nextQuestion)
                )
            } else {
                router.route(to: result)
            }
        }
    }
    
}

