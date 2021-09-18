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
        
        let controller = makeRawQuestionController(from: sut)
        let questionViewController = controller as? QuestionViewController
        
        XCTAssertNotNil(questionViewController)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithQuestion() {
        let sut = makeSUT()
        
        let controller = makeQuestionController(from: sut)
        
        XCTAssertEqual(controller.question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        let sut = makeSUT()
        
        let controller = makeQuestionController(from: sut)
        
        XCTAssertEqual(controller.options, options)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithSingleSelection() {
        let sut = makeSUT()
        
        let controller = makeQuestionController(from: sut)
        controller.loadViewIfNeeded()
        
        XCTAssertFalse(controller.tableView.allowsMultipleSelection)
    }
    
    // MARK:- Helpers
    
    func makeSUT() -> iOSViewControllerFactory {
        let sut = iOSViewControllerFactory(options: [question: options])
        return sut
    }
    
    func makeRawQuestionController(
        from sut: iOSViewControllerFactory
    ) -> UIViewController {
        return sut.questionViewController(
            for: question,
            answerCallback: { _ in }
        )
    }
    
    func makeQuestionController(
        from sut: iOSViewControllerFactory
    ) -> QuestionViewController {
        let controller = makeRawQuestionController(from: sut)
        return controller as! QuestionViewController
    }
    
}
