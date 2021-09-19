//
//  iOSViewControllerFactoryTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 17.09.21.
//

import XCTest

@testable import QuizApp

class iOSViewControllerFactoryTests: XCTestCase {
    
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q2")
    let options = ["A1", "A2"]
    
    func test_questionViewController_isCreatedForSingleOption() {
        let controller = makeRawQuestionController(question: singleAnswerQuestion)
        let questionViewController = controller as? QuestionViewController
        
        XCTAssertNotNil(questionViewController)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(
            allQuestions: [singleAnswerQuestion, multipleAnswerQuestion],
            currentQuestion: singleAnswerQuestion
        )
        let controller = makeQuestionController(question: singleAnswerQuestion)
        
        XCTAssertEqual(controller.title, presenter.title)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithQuestion() {
        let controller = makeQuestionController(question: singleAnswerQuestion)
        
        XCTAssertEqual(controller.question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        let controller = makeQuestionController(question: singleAnswerQuestion)
        
        XCTAssertEqual(controller.options, options)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithSingleSelection() {
        let controller = makeQuestionController(question: singleAnswerQuestion)
        
        XCTAssertFalse(controller.allowsMultipleSelection)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(
            allQuestions: [singleAnswerQuestion, multipleAnswerQuestion],
            currentQuestion: multipleAnswerQuestion
        )
        let controller = makeQuestionController(question: multipleAnswerQuestion)
        
        XCTAssertEqual(controller.title, presenter.title)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithQuestion() {
        let controller = makeQuestionController(question: multipleAnswerQuestion)
        
        XCTAssertEqual(controller.question, "Q2")
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        let controller = makeQuestionController(question: multipleAnswerQuestion)
        
        XCTAssertEqual(controller.options, options)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithSingleSelection() {
        let controller = makeQuestionController(question: multipleAnswerQuestion)
        
        XCTAssertTrue(controller.allowsMultipleSelection)
    }
    
    // MARK:- Helpers
    
    func makeSUT(
        options: [Question<String>: [String]] = [:]
    ) -> iOSViewControllerFactory {
        let sut = iOSViewControllerFactory(
            questions: [singleAnswerQuestion, multipleAnswerQuestion],
            options: options
        )
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
