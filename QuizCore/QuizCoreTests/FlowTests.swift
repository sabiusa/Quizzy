//
//  FlowTests.swift
//  QuizCoreTests
//
//  Created by Saba Khutsishvili on 15.09.21.
//

import Foundation
import XCTest

@testable import QuizCore

class FlowTests: XCTestCase {
    
    func test_start_withNoQuestions_doesNoRouteToQuestion() {
        let sut = makeSUT(questions: [])
        
        sut.start()
        
        XCTAssertEqual(delegate.routedQuestionCount, 0)
    }
    
    func test_start_withOneQuestions_routesToCorrectQuestion() {
        let sut = makeSUT(questions: ["Q1"])
        
        sut.start()
        
        XCTAssertEqual(delegate.routedQuestions, ["Q1"])
    }
    
    func test_start_withTwoQuestions_routesToFirstQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        
        XCTAssertEqual(delegate.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_routesToFirstQuestionTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        sut.start()

        XCTAssertEqual(delegate.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstTwoQuestions_withThreeQuestions_routesToSecondAndThirdQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        
        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.routedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotRouteToAnotherQuestion() {
        let sut = makeSUT(questions: ["Q1"])
        
        sut.start()
        delegate.answerCallback("A1")
        
        XCTAssertEqual(delegate.routedQuestions, ["Q1"])
    }
    
    func test_start_withNoQuestions_routesToResult() {
        let sut = makeSUT(questions: [])
        
        sut.start()
        
        XCTAssertEqual(delegate.routedResult!.answers, [:])
    }
    
    func test_start_withOneQuestions_doesNotRouteToResult() {
        let sut = makeSUT(questions: ["Q1"])
        
        sut.start()
        
        XCTAssertNil(delegate.routedResult)
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotRouteToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        delegate.answerCallback("A1")
        
        XCTAssertNil(delegate.routedResult)
    }
    
    func test_startAndAnswerFirstTwoQuestions_withTwoQuestions_routesToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.routedResult!.answers, ["Q1": "A1", "Q2": "A2"])
    }
    
    func test_startAndAnswerFirstTwoQuestions_withTwoQuestions_scores() {
        let sut = makeSUT(
            questions: ["Q1", "Q2"],
            scoring: { _ in 10 }
        )
        
        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.routedResult!.score, 10)
    }
    
    func test_startAndAnswerFirstTwoQuestions_withTwoQuestions_scoresWithRightAnswers() {
        var receivedAnswers = [String: String]()
        let sut = makeSUT(
            questions: ["Q1", "Q2"],
            scoring: { answers in
                receivedAnswers = answers
                return 20
            }
        )
        
        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(receivedAnswers, ["Q1": "A1", "Q2": "A2"])
    }
    
    // MARK:- Helpers
    
    private let delegate = DelegateSpy()
    
    private weak var weakSUT: Flow<DelegateSpy>?
    
    override func tearDown() {
        super.tearDown()
        
        XCTAssertNil(weakSUT, "Expected weakSUT to be deallocated, possible memory leak")
    }
    
    private func makeSUT(
        questions: [String],
        scoring: @escaping ([String: String]) -> Int = { _ in 0 }
    ) -> Flow<DelegateSpy> {
        let sut = Flow(
            questions: questions,
            router: delegate,
            scoring: scoring
        )
        weakSUT = sut
        return sut;
    }
    
    private class DelegateSpy: Router {
        
        var routedQuestions = [String]()
        var routedResult: QuizResult<String, String>? = nil
        
        var answerCallback: ((String) -> Void) = { _ in }
        
        var routedQuestionCount: Int {
            return routedQuestions.count
        }
        
        func route(
            to question: String,
            answerCallback: @escaping (String) -> Void
        ) {
            self.routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
        func route(to result: QuizResult<String, String>) {
            routedResult = result
        }
        
    }
    
}
