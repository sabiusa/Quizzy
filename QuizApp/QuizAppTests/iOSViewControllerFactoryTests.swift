//
//  iOSViewControllerFactoryTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 17.09.21.
//

import XCTest

@testable import QuizApp

class iOSViewControllerFactoryTests: XCTestCase {
    
    let options = ["A1", "A2"]
    
    func test_questionViewController_isCreatedForSingleOption() {
        let controller = makeRawQuestionController(question: .singleAnswer("Q1"))
        let questionViewController = controller as? QuestionViewController
        
        XCTAssertNotNil(questionViewController)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithQuestion() {
        let question = "Q1"
        let controller = makeQuestionController(question: .singleAnswer(question))
        
        XCTAssertEqual(controller.question, question)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        let controller = makeQuestionController(question: .singleAnswer("Q1"))
        
        XCTAssertEqual(controller.options, options)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithSingleSelection() {
        let controller = makeQuestionController(question: .singleAnswer("Q1"))
        controller.loadViewIfNeeded()
        
        XCTAssertFalse(controller.tableView.allowsMultipleSelection)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithQuestion() {
        let question = "Q1"
        let controller = makeQuestionController(question: .multipleAnswer(question))
        
        XCTAssertEqual(controller.question, question)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        let controller = makeQuestionController(question: .multipleAnswer("Q1"))
        
        XCTAssertEqual(controller.options, options)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithSingleSelection() {
        let controller = makeQuestionController(question: .multipleAnswer("Q1"))
        controller.loadViewIfNeeded()
        
        XCTAssertTrue(controller.tableView.allowsMultipleSelection)
    }
    
    // MARK:- Helpers
    
    func makeSUT(
        options: [Question<String>: [String]] = [:]
    ) -> iOSViewControllerFactory {
        let sut = iOSViewControllerFactory(options: options)
        return sut
    }
    
    func makeRawQuestionController(question: Question<String>) -> UIViewController {
        let sut = makeSUT(options: [question: options])
        return sut.questionViewController(
            for: question,
            answerCallback: { _ in }
        )
    }
    
    func makeQuestionController(question: Question<String>) -> QuestionViewController {
        let controller = makeRawQuestionController(question: question)
        return controller as! QuestionViewController
    }
    
}
