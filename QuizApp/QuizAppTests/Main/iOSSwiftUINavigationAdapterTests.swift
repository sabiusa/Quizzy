//
//  iOSSwiftUINavigationAdapterTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 22.09.21.
//

import SwiftUI
import XCTest
import QuizCore

@testable import QuizApp

class iOSSwiftUINavigationAdapterTests: XCTestCase {
    
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
        let (resultsView, presenter) = makeResults()
        
        XCTAssertEqual(resultsView.title, presenter.title)
    }
    
    func test_resultsViewController_createsControllerWithSummary() {
        let (resultsView, presenter) = makeResults()
        
        XCTAssertEqual(resultsView.summary, presenter.summary)
    }
    
    func test_resultsViewController_createsControllerWithPresentableAnswers() {
        let (resultsView, presenter) = makeResults()
        
        XCTAssertEqual(resultsView.answers, presenter.presentableAnswers)
    }
    
    func test_resultsViewController_createsControllerWithPlayAgainAction() {
        var playAgainCount = 0
        let (resultsView, _) = makeResults(playAgain: { playAgainCount += 1 })
        
        XCTAssertEqual(playAgainCount, 0)
        
        resultsView.playAgain()
        XCTAssertEqual(playAgainCount, 1)
        
        resultsView.playAgain()
        XCTAssertEqual(playAgainCount, 2)
    }
    
    func test_answerForQuestion_replacesNavigationStack() {
        let (sut, navigation) = makeSUT()
        
        sut.answer(for: singleAnswerQuestion) { _ in }
        XCTAssertEqual(navigation.viewControllers.count, 1)
        XCTAssertTrue(navigation.viewControllers[0] is UIHostingController<SingleAnswerQuestionView>)
        
        sut.answer(for: multipleAnswerQuestion) { _ in }
        XCTAssertEqual(navigation.viewControllers.count, 1)
        XCTAssertTrue(navigation.viewControllers[0] is UIHostingController<MultipleAnswerQuestionView>)
    }
    
    func test_didCompleteQuiz_replacesNavigationStack() {
        let (sut, navigation) = makeSUT()
        
        sut.didCompleteQuiz(with: correctAnswers)
        XCTAssertEqual(navigation.viewControllers.count, 1)
        XCTAssertTrue(navigation.viewControllers[0] is UIHostingController<ResultsView>)
        
        sut.didCompleteQuiz(with: correctAnswers)
        XCTAssertEqual(navigation.viewControllers.count, 1)
        XCTAssertTrue(navigation.viewControllers[0] is UIHostingController<ResultsView>)
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
    
    private func makeSUT(
        playAgain: @escaping () -> Void = {}
    ) -> (iOSSwiftUINavigationAdapter, UINavigationController) {
        let navigation = NonAnimatedNavigationController()
        let shower = ReplaceStrategy(navigationController: navigation)
        let sut = iOSSwiftUINavigationAdapter(
            shower: shower,
            options: options,
            correctAnswers: correctAnswers,
            playAgain: playAgain
        )
        return (sut, navigation)
    }
    
    func makeRawSingleAnswerQuestionView(
        answerCallback: @escaping ([String]) -> Void = { _ in }
    ) -> UIViewController? {
        let (sut, navigation) = makeSUT()
        sut.answer(for: singleAnswerQuestion, completion: answerCallback)
        return navigation.topViewController
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
    ) -> UIViewController? {
        let (sut, navigation) = makeSUT()
        sut.answer(for: multipleAnswerQuestion, completion: answerCallback)
        return navigation.topViewController
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
    
    func makeResults(
        playAgain: @escaping () -> Void = {}
    ) -> (ResultsView, ResultsPresenter) {
        let presenter = ResultsPresenter(
            userAnswers: correctAnswers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score
        )
        
        let (sut, navigation) = makeSUT(playAgain: playAgain)
        sut.didCompleteQuiz(with: correctAnswers)
        let controller = navigation.topViewController
        let resultHost = controller as! UIHostingController<ResultsView>
        
        return (resultHost.rootView, presenter)
    }
    
}


