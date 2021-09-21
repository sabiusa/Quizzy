//
//  QuizTests.swift
//  QuizCoreTests
//
//  Created by Saba Khutsishvili on 20.09.21.
//

import XCTest
import QuizCore

class QuizTests: XCTestCase {
    
    private var quiz: Quiz!
    
    func test_startQuiz_answerAllQuestions_completesQuizWithAnswers() {
        let delegate = DelegateSpy()
        
        quiz = Quiz.start(
            questions: ["Q1", "Q2"],
            delegate: delegate
        )
        
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
    }
    
    // MARK:- Helpers
    
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
        
        var completedQuizzes: [[(String, String)]] = []
        
        var answerCompletion: ((String) -> Void) = { _ in }
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            self.answerCompletion = completion
        }
        
        func didCompleteQuiz(with answers: [(question: String, answer: String)]) {
            completedQuizzes.append(answers)
        }
        
        func handle(result: QuizResult<String, String>) {}
        
    }
    
}

