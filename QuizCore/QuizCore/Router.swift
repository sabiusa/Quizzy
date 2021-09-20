//
//  Router.swift
//  QuizCore
//
//  Created by Saba Khutsishvili on 16.09.21.
//

import Foundation

@available(*, deprecated)
public protocol Router {
    
    associatedtype Question: Hashable
    associatedtype Answer
    
    func route(
        to question: Question,
        answerCallback: @escaping (Answer) -> Void
    )
    
    func route(to result: QuizResult<Question, Answer>)
    
}
