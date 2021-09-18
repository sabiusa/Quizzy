//
//  iOSViewControllerFactoryTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 17.09.21.
//

import XCTest

@testable import QuizApp

class iOSViewControllerFactoryTests: XCTestCase {
    
    let question = Question.singleAnswer("Q1")
    let options = ["A1", "A2"]
    
    func test_questionViewController_isCreatedForSingleOption() {
        let sut = makeSUT()
        
        let controller = sut.questionViewController(
            for: Question.singleAnswer("Q1"),
            answerCallback: { _ in }
        )
        let questionViewController = controller as? QuestionViewController
        
        XCTAssertNotNil(questionViewController)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithQuestion() {
        let sut = makeSUT()
        
        let controller = sut.questionViewController(
            for: Question.singleAnswer("Q1"),
            answerCallback: { _ in }
        ) as! QuestionViewController
        
        XCTAssertEqual(controller.question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        let sut = makeSUT()
        
        let controller = sut.questionViewController(
            for: question,
            answerCallback: { _ in }
        ) as! QuestionViewController
        
        XCTAssertEqual(controller.options, options)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithSingleSelection() {
        let sut = makeSUT()
        
        let controller = sut.questionViewController(
            for: question,
            answerCallback: { _ in }
        ) as! QuestionViewController
        controller.loadViewIfNeeded()
        
        XCTAssertFalse(controller.tableView.allowsMultipleSelection)
    }
    
    // MARK:- Helpers
    
    func makeSUT() -> iOSViewControllerFactory {
        let sut = iOSViewControllerFactory(options: [question: options])
        return sut
    }
    
}
