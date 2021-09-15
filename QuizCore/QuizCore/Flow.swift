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
}

class Flow {
    
    let router: Router
    let questions: [String]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.route(
                to: firstQuestion,
                answerCallback: route(toNext: firstQuestion)
            )
        }
    }
    
    func route(toNext question: String) -> Router.AnswerCallback {
        return { [weak self] _ in
            guard let self = self else { return }
            let currentQuestionIndex = self.questions.firstIndex(of: question)!
            let nextQuestion = self.questions[currentQuestionIndex + 1]
            self.router.route(
                to: nextQuestion,
                answerCallback: self.route(toNext: nextQuestion)
            )
        }
    }
    
}

