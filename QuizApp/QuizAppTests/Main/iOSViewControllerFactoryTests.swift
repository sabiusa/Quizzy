//
//  iOSUIKitViewControllerFactoryTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 17.09.21.
//

import XCTest
import TextualQuizDomain

@testable import QuizApp

class iOSUIKitViewControllerFactoryTests: XCTestCase {
    
    func test_questionViewController_isCreatedForSingleOption() {
        let controller = makeRawQuestionController(question: singleAnswerQuestion)
        let questionViewController = controller as? QuestionViewController
        
        XCTAssertNotNil(questionViewController)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(
            allQuestions: questions,
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
        
        XCTAssertEqual(controller.options, options[singleAnswerQuestion])
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithSingleSelection() {
        let controller = makeQuestionController(question: singleAnswerQuestion)
        
        XCTAssertFalse(controller.allowsMultipleSelection)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(
            allQuestions: questions,
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
        
        XCTAssertEqual(controller.options, options[multipleAnswerQuestion])
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithSingleSelection() {
        let controller = makeQuestionController(question: multipleAnswerQuestion)
        
        XCTAssertTrue(controller.allowsMultipleSelection)
    }
    
    func test_resultsViewController_createsControllerWithTitle() {
        let (resultController, presenter) = makeResults()
        
        XCTAssertEqual(resultController.title, presenter.title)
    }
    
    func test_resultsViewController_createsControllerWithSummary() {
        let (resultController, presenter) = makeResults()
        
        XCTAssertEqual(resultController.summary, presenter.summary)
    }
    
    func test_resultsViewController_createsControllerWithPresentableAnswers() {
        let (resultController, presenter) = makeResults()
        
        XCTAssertEqual(resultController.answers.count, presenter.presentableAnswers.count)
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
    
    private func makeSUT() -> iOSUIKitViewControllerFactory {
        let sut = iOSUIKitViewControllerFactory(
            options: options,
            correctAnswers: correctAnswers
        )
        return sut
    }
    
    func makeRawQuestionController(
        question: Question<String>,
        answerCallback: @escaping ([String]) -> Void = { _ in }
    ) -> UIViewController {
        let sut = makeSUT()
        return sut.questionViewController(
            for: question,
            answerCallback: answerCallback
        )
    }
    
    func makeQuestionController(
        question: Question<String>,
        answerCallback: @escaping ([String]) -> Void = { _ in }
    ) -> QuestionViewController {
        let controller = makeRawQuestionController(
            question: question,
            answerCallback: answerCallback
        )
        return controller as! QuestionViewController
    }
    
    func makeResults() -> (ResultsViewController, ResultsPresenter) {
        let presenter = ResultsPresenter(
            userAnswers: correctAnswers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score
        )
        
        let sut = makeSUT()
        let controller = sut.resultViewController(for: correctAnswers)
        let resultController = controller as! ResultsViewController
        
        return (resultController, presenter)
    }
    
}
