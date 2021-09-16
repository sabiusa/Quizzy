//
//  RouterSpy.swift
//  QuizCoreTests
//
//  Created by Saba Khutsishvili on 16.09.21.
//

import QuizCore

class RouterSpy: Router {
    
    var routedQuestions = [String]()
    var routedResult: QuizResult<String, String>? = nil
    
    var answerCallback: ((String) -> Void) = { _ in }
    
    var routedQuestionCount: Int {
        return routedQuestions.count
    }
    
    func route(
        to question: String,
        answerCallback: @escaping (String) -> Void
    ) {
        self.routedQuestions.append(question)
        self.answerCallback = answerCallback
    }
    
    func route(to result: QuizResult<String, String>) {
        routedResult = result
    }
    
}
