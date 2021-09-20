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
    
    public static func start<Question, Answer: Equatable, Delegate: QuizDelegate>(
        questions: [Question],
        delegate: Delegate,
        correctAnswers: [Question: Answer]
    ) -> Quiz
    where Delegate.Question == Question,
          Delegate.Answer == Answer
    {
        let flow = Flow(
            questions: questions,
            delegate: delegate,
            scoring: { answers in
                scoring(
                    answers: answers,
                    correctAnswers: correctAnswers
                )
            }
        )
        flow.start()
        return Quiz(flow: flow)
    }
    
}
