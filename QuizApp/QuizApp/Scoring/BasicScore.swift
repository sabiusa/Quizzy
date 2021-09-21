//
//  BasicScore.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 21.09.21.
//

import Foundation

final class BasicScore<T: Equatable> {
    
    static func score(
        for userAnswers: [T],
        comparedTo correctAnswers: [T]
    ) -> Int {
        return zip(userAnswers, correctAnswers).reduce(0) { score, tuple in
            return score + (tuple.0 == tuple.1 ? 1 : 0)
        }
    }
    
}
