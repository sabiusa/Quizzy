//
//  iOSSwiftUIViewControllerFactoryTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 22.09.21.
//

import SwiftUI
import XCTest
import QuizCore

@testable import QuizApp

class iOSSwiftUIViewControllerFactoryTests: XCTestCase {
    
    func test_questionViewController_isCreatedForSingleOption() {
        let controller = makeRawSingleAnswerQuestionView()
        let singleAnswerView = controller as? UIHostingController<SingleAnswerQuestionView>
        
        XCTAssertNotNil(singleAnswerView)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(
            allQuestions: questions,
            currentQuestion: singleAnswerQuestion
        )
        let singleAnswerView = makeSingleAnswerQuestionView()
        
        XCTAssertEqual(singleAnswerView.title, presenter.title)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithQuestion() {
        let singleAnswerView = makeSingleAnswerQuestionView()
        
        XCTAssertEqual(singleAnswerView.question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        let singleAnswerView = makeSingleAnswerQuestionView()
        
        XCTAssertEqual(singleAnswerView.options, options[singleAnswerQuestion])
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithAnswerCallback() {
        var answers = [[String]]()
        let singleAnswerView = makeSingleAnswerQuestionView(answerCallback: {
            answers.append($0)
        })
        
        XCTAssertEqual(answers, [])
        
        let option1 = singleAnswerView.options[0]
        singleAnswerView.selection(option1)
        XCTAssertEqual(answers, [[option1]])
        
        let option2 = singleAnswerView.options[1]
        singleAnswerView.selection(option2)
        XCTAssertEqual(answers, [[option1], [option2]])
    }
    
    func test_questionViewController_isCreatedForMultipleOption() {
        let controller = makeRawMultipleAnswerQuestionView()
        let multipleAnswerView = controller as? UIHostingController<MultipleAnswerQuestionView>
        
        XCTAssertNotNil(multipleAnswerView)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(
            allQuestions: questions,
            currentQuestion: multipleAnswerQuestion
        )
        let multipleAnswerView = makeMultipleAnswerQuestionView()

        XCTAssertEqual(multipleAnswerView.title, presenter.title)
    }

    func test_questionViewController_multipleAnswer_createsControllerWithQuestion() {
        let multipleAnswerView = makeMultipleAnswerQuestionView()

        XCTAssertEqual(multipleAnswerView.question, "Q2")
    }

    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        let multipleAnswerView = makeMultipleAnswerQuestionView()
        
        XCTAssertEqual(multipleAnswerView.store.options.map(\.text), options[multipleAnswerQuestion])
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
    
    private func makeSUT() -> iOSSwiftUIViewControllerFactory {
        let sut = iOSSwiftUIViewControllerFactory(
            options: options,
            correctAnswers: correctAnswers
        )
        return sut
    }
    
    func makeRawSingleAnswerQuestionView(
        answerCallback: @escaping ([String]) -> Void = { _ in }
    ) -> UIViewController {
        let sut = makeSUT()
        return sut.questionViewController(
            for: singleAnswerQuestion,
            answerCallback: answerCallback
        )
    }
    
    func makeSingleAnswerQuestionView(
        answerCallback: @escaping ([String]) -> Void = { _ in }
    ) -> SingleAnswerQuestionView {
        let controller = makeRawSingleAnswerQuestionView(
            answerCallback: answerCallback
        )
        let host = controller as! UIHostingController<SingleAnswerQuestionView>
        return host.rootView
    }
    
    func makeRawMultipleAnswerQuestionView(
        answerCallback: @escaping ([String]) -> Void = { _ in }
    ) -> UIViewController {
        let sut = makeSUT()
        return sut.questionViewController(
            for: multipleAnswerQuestion,
            answerCallback: answerCallback
        )
    }
    
    func makeMultipleAnswerQuestionView(
        answerCallback: @escaping ([String]) -> Void = { _ in }
    ) -> MultipleAnswerQuestionView {
        let controller = makeRawMultipleAnswerQuestionView(
            answerCallback: answerCallback
        )
        let host = controller as! UIHostingController<MultipleAnswerQuestionView>
        return host.rootView
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

