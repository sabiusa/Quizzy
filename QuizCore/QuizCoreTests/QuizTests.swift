//
//  QuizTests.swift
//  QuizCoreTests
//
//  Created by Saba Khutsishvili on 20.09.21.
//

import XCTest
import QuizCore

class QuizTests: XCTestCase {
    
    private let delegate = DelegateSpy()
    private var quiz: Quiz!
    
    override func setUp() {
        super.setUp()
        
        quiz = Quiz.start(
            questions: ["Q1", "Q2"],
            delegate: delegate,
            correctAnswers: ["Q1": "A1", "Q2": "A2"]
        )
    }
    
    func test_startQuiz_answerZeroOutOfTwoCorrectly_scoresZero() {
        
        delegate.answerCallback("wrong")
        delegate.answerCallback("wrong")
        
        XCTAssertEqual(delegate.handledResult!.score, 0)
    }
    
    func test_startQuiz_answerOneOutOfTwoCorrectly_scoresOne() {
        
        delegate.answerCallback("A1")
        delegate.answerCallback("wrong")
        
        XCTAssertEqual(delegate.handledResult!.score, 1)
    }
    
    func test_startQuiz_answerTwoOutOfTwoCorrectly_scoresTwo() {
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.handledResult!.score, 2)
    }
    
    // MARK:- Helpers
    
    private class DelegateSpy: Router, QuizDelegate {
        
        var handledResult: QuizResult<String, String>? = nil
        
        var answerCallback: ((String) -> Void) = { _ in }
        
        func handle(question: String, answerCallback: @escaping (String) -> Void) {
            self.answerCallback = answerCallback
        }
        
        func route(
            to question: String,
            answerCallback: @escaping (String) -> Void
        ) {
            handle(question: question, answerCallback: answerCallback)
        }
        
        func handle(result: QuizResult<String, String>) {
            handledResult = result
        }
        
        func route(to result: QuizResult<String, String>) {
            handle(result: result)
        }
        
    }
    
}

