//
//  QuizTests.swift
//  QuizCoreTests
//
//  Created by Saba Khutsishvili on 20.09.21.
//

import XCTest
import QuizCore

class QuizTests: XCTestCase {
    
    private let router = RouterSpy()
    private var game: Game<String, String, RouterSpy>!
    
    override func setUp() {
        super.setUp()
        
        game = startGame(
            questions: ["Q1", "Q2"],
            router: router,
            correctAnswers: ["Q1": "A1", "Q2": "A2"]
        )
    }
    
    func test_startGame_answerZeroOutOfTwoCorrectly_scoresZero() {
        
        router.answerCallback("wrong")
        router.answerCallback("wrong")
        
        XCTAssertEqual(router.routedResult!.score, 0)
    }
    
    func test_startGame_answerOneOutOfTwoCorrectly_scoresOne() {
        
        router.answerCallback("A1")
        router.answerCallback("wrong")
        
        XCTAssertEqual(router.routedResult!.score, 1)
    }
    
    func test_startGame_answerTwoOutOfTwoCorrectly_scoresTwo() {
        
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedResult!.score, 2)
    }
    
    // MARK:- Helpers
    
    private class RouterSpy: Router {
        
        var routedResult: QuizResult<String, String>? = nil
        
        var answerCallback: ((String) -> Void) = { _ in }
        
        func route(
            to question: String,
            answerCallback: @escaping (String) -> Void
        ) {
            self.answerCallback = answerCallback
        }
        
        func route(to result: QuizResult<String, String>) {
            routedResult = result
        }
        
    }
    
}

