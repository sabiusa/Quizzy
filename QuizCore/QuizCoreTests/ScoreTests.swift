//
//  ScoreTests.swift
//  QuizCoreTests
//
//  Created by Saba Khutsishvili on 21.09.21.
//

import XCTest

class ScoreTests: XCTestCase {
    
    func test_noAnswers_scoresZero() {
        let score = BasicScore.score(for: [], comparedTo: [])
        
        XCTAssertEqual(score, 0)
    }
    
    func test_oneNonMatchingAnswer_scoresZero() {
        let score = BasicScore.score(for: ["no match"], comparedTo: ["answer"])
        
        XCTAssertEqual(score, 0)
    }
    
    func test_oneMatchingAnswer_scoresOne() {
        let score = BasicScore.score(for: ["answer"], comparedTo: ["answer"])
        
        XCTAssertEqual(score, 1)
    }
    
    func test_oneMatchingAnswerOneNonMatching_scoresOne() {
        let score = BasicScore.score(
            for: ["answer", "wrong"],
            comparedTo: ["answer", "another answer"]
        )
        
        XCTAssertEqual(score, 1)
    }
    
    func test_twoMatchingAnswers_scoresTwo() {
        let score = BasicScore.score(
            for: ["answer", "another answer"],
            comparedTo: ["answer", "another answer"]
        )
        
        XCTAssertEqual(score, 2)
    }
    
    func test_withTooManyUserAnswers_twoMatchingAnswers_scoresTwo() {
        let score = BasicScore.score(
            for: ["answer", "another answer", "extra answer"],
            comparedTo: ["answer", "another answer"]
        )
        
        XCTAssertEqual(score, 2)
    }
    
    func test_withTooManyCorrectAnswers_oneMatchingAnswer_scoresOne() {
        let score = BasicScore.score(
            for: ["no match", "another answer"],
            comparedTo: ["answer", "another answer", "extra answer"]
        )
        
        XCTAssertEqual(score, 1)
    }
    
    private class BasicScore {
        
        static func score(
            for userAnswers: [String],
            comparedTo correctAnswers: [String]
        ) -> Int {
            var score = 0
            for (index, answer) in userAnswers.enumerated() {
                if index >= correctAnswers.count { return score }
                score += (answer == correctAnswers[index]) ? 1 : 0
            }
            return score
        }
        
    }
    
}
