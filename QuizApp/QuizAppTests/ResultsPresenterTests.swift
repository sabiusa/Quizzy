//
//  ResultsPresenterTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 19.09.21.
//

import XCTest
import QuizCore

@testable import QuizApp

class ResultsPresenterTests: XCTestCase {
    
    func test_summary_withTwoQuestionsAnsScoreOne_returnsSummary() {
        let answers = [
            Question.singleAnswer("Q1"): ["A1"],
            Question.multipleAnswer("Q2"): ["A2", "A3"]
        ]
        let result = QuizResult.make(answers: answers, score: 1)
        
        let sut = ResultsPresenter(result: result)
        
        XCTAssertEqual(sut.summary, "You go 1/2 correct")
    }
    
    func test_presentableAnswers_empty_shouldBeEmpty() {
        let answers = [Question<String>: [String]]()
        let result = QuizResult.make(answers: answers, score: 0)
        
        let sut = ResultsPresenter(result: result)
        
        XCTAssertTrue(sut.presentableAnswers.isEmpty)
    }
    
}
