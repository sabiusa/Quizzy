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

func scoring<Question, Answer: Equatable>(
    answers: [Question: Answer],
    correctAnswers: [Question: Answer]
) -> Int {
    return answers.reduce(0) { score, kvp in
        let current = correctAnswers[kvp.key] == kvp.value ? 1 : 0
        return score + current
    }
}
