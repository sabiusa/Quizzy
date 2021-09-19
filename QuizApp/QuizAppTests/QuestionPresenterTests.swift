//
//  QuestionPresenterTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 19.09.21.
//

import XCTest

@testable import QuizApp

class QuestionPresenterTests: XCTestCase {
    
    func test_title_forFirstQuestion() {
        let question1 = Question.singleAnswer("Q1")
        
        let sut = QuestionPresenter(
            allQuestions: [question1],
            currentQuestion: question1
        )
        
        XCTAssertEqual(sut.title, "Question #1")
    }
    
}
