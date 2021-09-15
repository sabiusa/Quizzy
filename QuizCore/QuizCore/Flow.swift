//
//  Flow.swift
//  QuizCore
//
//  Created by Saba Khutsishvili on 15.09.21.
//

import Foundation

protocol Router {
    func route(
        to question: String,
        answerCallback: @escaping (String) -> Void
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
            router.route(to: firstQuestion) { [weak self] _ in
                guard let self = self else { return }
                let firstQuestionIndex = self.questions.firstIndex(of: firstQuestion)!
                let nextQuestion = self.questions[firstQuestionIndex + 1]
                self.router.route(to: nextQuestion, answerCallback: { _ in })
            }
        }
    }
    
}

