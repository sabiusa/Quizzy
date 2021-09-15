//
//  Flow.swift
//  QuizCore
//
//  Created by Saba Khutsishvili on 15.09.21.
//

import Foundation

protocol Router {
    func route(to question: String)
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
            router.route(to: firstQuestion)
        }
    }
    
}

