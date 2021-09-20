//
//  QuizResultHelpers.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 19.09.21.
//

@testable import QuizCore

extension QuizResult {
    
    static func make(
        answers: [Question: Answer] = [:],
        score: Int = 0
    ) -> QuizResult {
        return QuizResult(answers: answers, score: score)
    }
    
}
 
extension QuizResult: Equatable where Answer: Equatable {
    
    public static func ==(
        lhs: QuizResult<Question, Answer>,
        rhs: QuizResult<Question, Answer>
    ) -> Bool {
        return
            lhs.score == rhs.score &&
            lhs.answers == rhs.answers
    }
    
}

extension QuizResult: Hashable where Answer: Equatable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(answers.map(\.key))
    }
    
}
