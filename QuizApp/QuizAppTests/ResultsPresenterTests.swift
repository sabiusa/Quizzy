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
    
    func test_summary_withThreeQuestionsAnsScoreTwo_returnsSummary() {
        let answers = [
            Question.singleAnswer("Q1"): ["A1"],
            Question.multipleAnswer("Q2"): ["A2", "A3"],
            Question.singleAnswer("Q3"): ["A4"]
        ]
        let result = QuizResult.make(answers: answers, score: 2)
        let sut = ResultsPresenter(result: result)
        
        XCTAssertEqual(sut.summary, "You go 2/3 correct")
    }
    
}
