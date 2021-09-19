//
//  QuestionPresenterTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 19.09.21.
//

import XCTest

@testable import QuizApp

class QuestionPresenterTests: XCTestCase {
    
    let question1 = Question.singleAnswer("Q1")
    let question2 = Question.multipleAnswer("Q2")
    
    func test_title_forFirstQuestion() {
        let sut = QuestionPresenter(
            allQuestions: [question1, question2],
            currentQuestion: question1
        )
        
        XCTAssertEqual(sut.title, "Question #1")
    }
    
    func test_title_formatsTitleForIndex() {
        let sut = QuestionPresenter(
            allQuestions: [question1, question2],
            currentQuestion: question2
        )
        
        XCTAssertEqual(sut.title, "Question #2")
    }
    
    func test_title_forNonexistantQuestion_isEmpty() {
        let sut = QuestionPresenter(
            allQuestions: [],
            currentQuestion: question1
        )
        
        XCTAssertNil(sut.title)
    }
    
}
