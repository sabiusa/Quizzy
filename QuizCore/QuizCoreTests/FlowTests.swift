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
    
    func test_start_withNoQuestions_doesNoDelegateQuestionHandling() {
        let sut = makeSUT(questions: [])
        
        sut.start()
        
        XCTAssertEqual(delegate.handledQuestionCount, 0)
    }
    
    func test_start_withOneQuestions_delegatesCorrectQuestionHandling() {
        let sut = makeSUT(questions: ["Q1"])
        
        sut.start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_start_withTwoQuestions_delegatesFirstQuestionHandling() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_delegatesFirstQuestionHandlingTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        sut.start()

        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstTwoQuestions_withThreeQuestions_delegatesSecondAndThirdQuestionHandling() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        
        sut.start()
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotDelegateAnotherQuestionHandling() {
        let sut = makeSUT(questions: ["Q1"])
        
        sut.start()
        delegate.answerCompletion("A1")
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestions_doesNotCompleteQuiz() {
        let sut = makeSUT(questions: ["Q1"])
        
        sut.start()
        
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }
    
    func test_start_withNoQuestions_delegatesResultHandling() {
        let sut = makeSUT(questions: [])
        
        sut.start()
        
        XCTAssertEqual(delegate.handledResult!.answers, [:])
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotRouteToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        delegate.answerCompletion("A1")
        
        XCTAssertNil(delegate.handledResult)
    }
    
    func test_startAndAnswerFirstTwoQuestions_withTwoQuestions_delegatesResultHandling() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")
        
        XCTAssertEqual(delegate.handledResult!.answers, ["Q1": "A1", "Q2": "A2"])
    }
    
    func test_startAndAnswerFirstTwoQuestions_withTwoQuestions_scores() {
        let sut = makeSUT(
            questions: ["Q1", "Q2"],
            scoring: { _ in 10 }
        )
        
        sut.start()
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")
        
        XCTAssertEqual(delegate.handledResult!.score, 10)
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
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")
        
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
            delegate: delegate,
            scoring: scoring
        )
        weakSUT = sut
        return sut;
    }
    
    private class DelegateSpy: QuizDelegate {
        
        var handledQuestions = [String]()
        var handledResult: QuizResult<String, String>? = nil
        var completedQuizzes: [[(String, String)]] = []
        
        var answerCompletion: ((String) -> Void) = { _ in }
        
        var handledQuestionCount: Int {
            return handledQuestions.count
        }
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            self.handledQuestions.append(question)
            self.answerCompletion = completion
        }
        
        func handle(result: QuizResult<String, String>) {
            handledResult = result
        }
        
    }
    
}
