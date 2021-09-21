//
//  Quiz.swift
//  QuizCore
//
//  Created by Saba Khutsishvili on 20.09.21.
//

import Foundation

public final class Quiz {
    
    let flow: Any
    
    init(flow: Any) {
        self.flow = flow
    }
    
    public static func start<Delegate: QuizDelegate>(
        questions: [Delegate.Question],
        delegate: Delegate
    ) -> Quiz
    where Delegate.Answer: Equatable {
        let flow = Flow(questions: questions, delegate: delegate)
        flow.start()
        return Quiz(flow: flow)
    }
    
}
