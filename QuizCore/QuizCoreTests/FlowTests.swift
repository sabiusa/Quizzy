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
        
        XCTAssertEqual(delegate.askedQuestions, ["Q1"])
    }
    
    func test_start_withTwoQuestions_delegatesFirstQuestionHandling() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        
        XCTAssertEqual(delegate.askedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_delegatesFirstQuestionHandlingTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        sut.start()

        XCTAssertEqual(delegate.askedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstTwoQuestions_withThreeQuestions_delegatesSecondAndThirdQuestionHandling() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        
        sut.start()
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        
        XCTAssertEqual(delegate.askedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotDelegateAnotherQuestionHandling() {
        let sut = makeSUT(questions: ["Q1"])
        
        sut.start()
        delegate.answerCompletions[0]("A1")
        
        XCTAssertEqual(delegate.askedQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestions_doesNotCompleteQuiz() {
        let sut = makeSUT(questions: ["Q1"])
        
        sut.start()
        
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }
    
    func test_start_withNoQuestions_completesWithEmptyQuiz() {
        let sut = makeSUT(questions: [])
        
        sut.start()
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        XCTAssertTrue(delegate.completedQuizzes[0].isEmpty)
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotCompleteQuiz() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        delegate.answerCompletions[0]("A1")
        
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }
    
    func test_startAndAnswerFirstTwoQuestions_withTwoQuestions_completesQuiz() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
    }
    
    func test_startAndAnswerFirstTwoQuestionsTwice_withTwoQuestions_completesQuizTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        
        delegate.answerCompletions[0]("A1-1")
        delegate.answerCompletions[1]("A2-2")
        
        XCTAssertEqual(delegate.completedQuizzes.count, 2)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
        assertEqual(delegate.completedQuizzes[1], [("Q1", "A1-1"), ("Q2", "A2-2")])
    }
    
    // MARK:- Helpers
    
    private let delegate = DelegateSpy()
    
    private weak var weakSUT: Flow<DelegateSpy>?
    
    override func tearDown() {
        super.tearDown()
        
        XCTAssertNil(weakSUT, "Expected weakSUT to be deallocated, possible memory leak")
    }
    
    private func makeSUT(
        questions: [String]
    ) -> Flow<DelegateSpy> {
        let sut = Flow(
            questions: questions,
            delegate: delegate
        )
        weakSUT = sut
        return sut;
    }
    
    private func assertEqual(
        _ a1: [(String, String)],
        _ a2: [(String, String)],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertTrue(
            a1.elementsEqual(a2, by: ==),
            "\(a1) does not equal \(a2)",
            file: file,
            line: line
        )
    }
    
    private class DelegateSpy: QuizDelegate {
        
        var askedQuestions = [String]()
        var answerCompletions: [(String) -> Void] = []
        var completedQuizzes: [[(String, String)]] = []
        
        var handledQuestionCount: Int {
            return askedQuestions.count
        }
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            self.askedQuestions.append(question)
            self.answerCompletions.append(completion)
        }
        
        func didCompleteQuiz(with answers: [(question: String, answer: String)]) {
            completedQuizzes.append(answers)
        }
        
    }
    
}
