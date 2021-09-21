//
//  ScoreTests.swift
//  QuizCoreTests
//
//  Created by Saba Khutsishvili on 21.09.21.
//

import XCTest

class ScoreTests: XCTestCase {
    
    func test_noAnswers_scoresZero() {
        let score = BasicScore.score(for: [], comparingTo: [])
        
        XCTAssertEqual(score, 0)
    }
    
    func test_oneWrongAnswer_scoresZero() {
        let score = BasicScore.score(for: ["wrong"], comparingTo: ["correct"])
        
        XCTAssertEqual(score, 0)
    }
    
    func test_oneCorrectAnswer_scoresOne() {
        let score = BasicScore.score(for: ["correct"], comparingTo: ["correct"])
        
        XCTAssertEqual(score, 1)
    }
    
    func test_oneCorrectAnswerOneWrong_scoresOne() {
        let score = BasicScore.score(
            for: ["correct 1", "wrong"],
            comparingTo: ["correct 1", "correct 2"]
        )
        
        XCTAssertEqual(score, 1)
    }
    
    private class BasicScore {
        
        static func score(
            for userAnswers: [String],
            comparingTo correctAnswers: [String]
        ) -> Int {
            var score = 0
            for (index, answer) in userAnswers.enumerated() {
                score += (answer == correctAnswers[index]) ? 1 : 0
            }
            return score
        }
        
    }
    
}
