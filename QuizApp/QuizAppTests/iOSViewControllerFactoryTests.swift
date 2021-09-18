//
//  iOSViewControllerFactoryTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 17.09.21.
//

import XCTest

@testable import QuizApp

class iOSViewControllerFactoryTests: XCTestCase {
    
    func test_questionViewController_isCreatedForSingleOption() {
        let question = Question.singleAnswer("Q1")
        let options = ["A1", "A2"]
        let sut = iOSViewControllerFactory(options: [question: options])
        
        let controller = sut.questionViewController(
            for: Question.singleAnswer("Q1"),
            answerCallback: { _ in }
        )
        let questionViewController = controller as? QuestionViewController
        
        XCTAssertNotNil(questionViewController)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithQuestion() {
        let question = Question.singleAnswer("Q1")
        let options = ["A1", "A2"]
        let sut = iOSViewControllerFactory(options: [question: options])
        
        let controller = sut.questionViewController(
            for: Question.singleAnswer("Q1"),
            answerCallback: { _ in }
        ) as! QuestionViewController
        
        XCTAssertEqual(controller.question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        let question = Question.singleAnswer("Q1")
        let options = ["A1", "A2"]
        let sut = iOSViewControllerFactory(options: [question: options])
        
        let controller = sut.questionViewController(
            for: question,
            answerCallback: { _ in }
        ) as! QuestionViewController
        
        XCTAssertEqual(controller.options, options)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithSingleSelection() {
        let question = Question.singleAnswer("Q1")
        let options = ["A1", "A2"]
        let sut = iOSViewControllerFactory(options: [question: options])
        
        let controller = sut.questionViewController(
            for: question,
            answerCallback: { _ in }
        ) as! QuestionViewController
        controller.loadViewIfNeeded()
        
        XCTAssertFalse(controller.tableView.allowsMultipleSelection)
    }
    
}
