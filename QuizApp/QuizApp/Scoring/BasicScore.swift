//
//  BasicScore.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 21.09.21.
//

import Foundation

final class BasicScore {
    
    static func score(
        for userAnswers: [String],
        comparedTo correctAnswers: [String]
    ) -> Int {
        return zip(userAnswers, correctAnswers).reduce(0) { score, tuple in
            return score + (tuple.0 == tuple.1 ? 1 : 0)
        }
    }
    
}
