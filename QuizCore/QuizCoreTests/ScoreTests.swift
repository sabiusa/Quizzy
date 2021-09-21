//
//  ScoreTests.swift
//  QuizCoreTests
//
//  Created by Saba Khutsishvili on 21.09.21.
//

import XCTest

class ScoreTests: XCTestCase {
    
    func test_noAnswers_scoresZero() {
        let score = BasicScore.score(for: [])
        
        XCTAssertEqual(score, 0)
    }
    
    private class BasicScore {
        
        static func score(for: [Any]) -> Int {
            return 0
        }
        
    }
    
}
