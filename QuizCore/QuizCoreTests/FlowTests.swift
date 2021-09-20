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
    
    private let router = RouterSpy()
    
    func test_start_withNoQuestions_doesNoRouteToQuestion() {
        let sut = makeSUT(questions: [])
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestionCount, 0)
    }
    
    func test_start_withOneQuestions_routesToCorrectQuestion() {
        let sut = makeSUT(questions: ["Q1"])
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withTwoQuestions_routesToFirstQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_routesToFirstQuestionTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstTwoQuestions_withThreeQuestions_routesToSecondAndThirdQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotRouteToAnotherQuestion() {
        let sut = makeSUT(questions: ["Q1"])
        
        sut.start()
        router.answerCallback("A1")
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withNoQuestions_routesToResult() {
        let sut = makeSUT(questions: [])
        
        sut.start()
        
        XCTAssertEqual(router.routedResult!.answers, [:])
    }
    
    func test_start_withOneQuestions_doesNotRouteToResult() {
        let sut = makeSUT(questions: ["Q1"])
        
        sut.start()
        
        XCTAssertNil(router.routedResult)
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotRouteToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        router.answerCallback("A1")
        
        XCTAssertNil(router.routedResult)
    }
    
    func test_startAndAnswerFirstTwoQuestions_withTwoQuestions_routesToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedResult!.answers, ["Q1": "A1", "Q2": "A2"])
    }
    
    func test_startAndAnswerFirstTwoQuestions_withTwoQuestions_scores() {
        let sut = makeSUT(
            questions: ["Q1", "Q2"],
            scoring: { _ in 10 }
        )
        
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedResult!.score, 10)
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
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(receivedAnswers, ["Q1": "A1", "Q2": "A2"])
    }
    
    // MARK:- Helpers
    
    private func makeSUT(
        questions: [String],
        scoring: @escaping ([String: String]) -> Int = { _ in 0 }
    ) -> Flow<String, String, RouterSpy> {
        let sut = Flow(
            questions: questions,
            router: router,
            scoring: scoring
        )
        return sut;
    }
    
    private class RouterSpy: Router {
        
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
