//
//  QuizNavigationStoreTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 24.09.21.
//

import XCTest
import QuizCore

@testable import QuizApp

class QuizNavigationStoreTests: XCTestCase {
    
    func test_publishesNavigationChanges() {
        let (sut, adapter) = makeSUT()
        
        var navigationChangeCount = 0
        let cancellable = sut.objectWillChange
            .sink { navigationChangeCount += 1 }
        
        XCTAssertEqual(navigationChangeCount, 0)
        
        adapter.answer(for: singleAnswerQuestion, completion: { _ in })
        XCTAssertEqual(navigationChangeCount, 1)
        
        adapter.answer(for: multipleAnswerQuestion, completion: { _ in })
        XCTAssertEqual(navigationChangeCount, 2)
        
        adapter.didCompleteQuiz(with: correctAnswers)
        XCTAssertEqual(navigationChangeCount, 3)
        
        cancellable.cancel()
    }
    
    // MARK:- Helpers
    
    private var singleAnswerQuestion: Question<String> { .singleAnswer("Q1") }
    private var multipleAnswerQuestion: Question<String> { .multipleAnswer("Q2") }
    
    private var questions: [Question<String>] {
        return [singleAnswerQuestion, multipleAnswerQuestion]
    }
    
    private var options: [Question<String>: [String]] {
        return [
            singleAnswerQuestion: ["A1", "A2", "A3"],
            multipleAnswerQuestion: ["A4", "A5", "A6"]
        ]
    }
    
    private var correctAnswers: [(Question<String>, [String])] {
        return [
            (singleAnswerQuestion, ["A1"]),
            (multipleAnswerQuestion, ["A4", "A5"])
        ]
    }
    
    private func makeSUT() -> (QuizNavigationStore, iOSSwiftUINavigationAdapter) {
        let sut = QuizNavigationStore()
        let adapter = iOSSwiftUINavigationAdapter(
            navigation: sut,
            options: options,
            correctAnswers: correctAnswers,
            playAgain: {}
        )
        return (sut, adapter)
    }
    
}
