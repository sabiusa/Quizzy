//
//  iOSSwiftUINavigationFlowAdapterTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 27.09.21.
//

import SwiftUI
import XCTest
import QuizCore

@testable import QuizApp

class iOSSwiftUINavigationFlowAdapterTests: XCTestCase {
    
    func test_answerFor_singleAnswerQuestion_createsControllerWithTitle() {
        let presenter = QuestionPresenter(
            allQuestions: questions,
            currentQuestion: singleAnswerQuestion
        )
        
        let singleAnswerView = makeSingleAnswerQuestionView()
        
        XCTAssertEqual(singleAnswerView.title, presenter.title)
    }
    
    func test_answerFor_singleAnswerQuestion_createsControllerWithCorrectData() {
        let singleAnswerView = makeSingleAnswerQuestionView()
        
        XCTAssertEqual(singleAnswerView.question, "Q1")
        XCTAssertEqual(singleAnswerView.options, options[singleAnswerQuestion])
    }
    
    func test_answerFor_singleAnswerQuestion_createsControllerWithAnswerCallback() {
        var selections = [[String]]()
        let singleAnswerView = makeSingleAnswerQuestionView(
            answerCallback: { answer in
                selections.append(answer)
            }
        )
        XCTAssertEqual(selections.count, 0)
        
        let option0 = singleAnswerView.options[0]
        singleAnswerView.selection(option0)
        XCTAssertEqual(selections, [[option0]])
        
        let option1 = singleAnswerView.options[1]
        singleAnswerView.selection(option1)
        XCTAssertEqual(selections, [[option0], [option1]])
    }
    
    func test_answerFor_multipleAnswerQuestion_createsControllerWithTitle() {
        let presenter = QuestionPresenter(
            allQuestions: questions,
            currentQuestion: multipleAnswerQuestion
        )
        
        let multipleAnswerView = makeMultipleAnswerQuestionView()
        
        XCTAssertEqual(multipleAnswerView.title, presenter.title)
    }
    
    func test_answerFor_multipleAnswerQuestion_createsControllerWithQuestion() {
        let multipleAnswerView = makeMultipleAnswerQuestionView()
        
        XCTAssertEqual(multipleAnswerView.question, "Q2")
    }
    
    func test_answerFor_multipleAnswerQuestion_createsControllerWithOptions() {
        let multipleAnswerView = makeMultipleAnswerQuestionView()
        
        XCTAssertEqual(multipleAnswerView.store.options.map(\.text), options[multipleAnswerQuestion])
    }
    
    func test_answerFor_multipleAnswerQuestion_createsControllerWithAnswerCallback() {
        var submittedAnswer = [String]()
        let multipleAnswerView = makeMultipleAnswerQuestionView(
            answerCallback: { answer in
                submittedAnswer = answer
            }
        )
        var store = multipleAnswerView.store
        
        let option0 = store.options[0].text
        store.options[0].toggleSelection()
        store.submit()
        XCTAssertEqual(submittedAnswer, [option0])
        
        let option1 = store.options[1].text
        store.options[1].toggleSelection()
        store.submit()
        XCTAssertEqual(submittedAnswer, [option0, option1])
        
        store.options[1].toggleSelection()
        store.submit()
        XCTAssertEqual(submittedAnswer, [option0])
    }
    
    func test_resultsViewController_createsControllerWithCorrectData() {
        let presenter = ResultsPresenter(
            userAnswers: correctAnswers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score
        )
        
        let resultsView = makeResults()
        
        XCTAssertEqual(resultsView.title, presenter.title)
        XCTAssertEqual(resultsView.summary, presenter.summary)
        XCTAssertEqual(resultsView.answers, presenter.presentableAnswers)
    }
    
    func test_resultsViewController_createsControllerWithPlayAgainCallback() {
        var playAgainCount = 0
        let resultsView = makeResults(playAgain: {
            playAgainCount += 1
        })
        XCTAssertEqual(playAgainCount, 0)
        
        resultsView.playAgain()
        XCTAssertEqual(playAgainCount, 1)
        
        resultsView.playAgain()
        XCTAssertEqual(playAgainCount, 2)
    }
    
    func test_answerForQuestion_replacesNavigationStack() {
        let (sut, navigator) = makeSUT()
        XCTAssertEqual(navigator.viewControllers.count, 0)
        
        sut.answer(for: singleAnswerQuestion, completion: { _ in })
        XCTAssertEqual(navigator.viewControllers.count, 1)
        XCTAssertNotNil(navigator.topSingleAnswerView)
        
        sut.answer(for: multipleAnswerQuestion, completion: { _ in })
        XCTAssertEqual(navigator.viewControllers.count, 1)
        XCTAssertNotNil(navigator.topMultipleAnswerView)
    }
    
    func test_didCompleteQuiz_replacesNavigationStack() {
        let (sut, navigator) = makeSUT()
        XCTAssertEqual(navigator.viewControllers.count, 0)
        
        sut.didCompleteQuiz(with: correctAnswers)
        XCTAssertEqual(navigator.viewControllers.count, 1)
        XCTAssertNotNil(navigator.topResultsView)
        
        sut.didCompleteQuiz(with: correctAnswers)
        XCTAssertEqual(navigator.viewControllers.count, 1)
        XCTAssertNotNil(navigator.topResultsView)
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
    ) ->(iOSSwiftUINavigationFlowAdapter, NonAnimatedNavigationController) {
        let navigator = NonAnimatedNavigationController()
        let sut = iOSSwiftUINavigationFlowAdapter(
            navigator: navigator,
            questions: questions,
            options: options,
            correctAnswers: correctAnswers,
            playAgain: playAgain
        )
        return (sut, navigator)
    }
    
    private func makeSingleAnswerQuestionView(
        answerCallback: @escaping ([String]) -> Void = { _ in }
    ) -> SingleAnswerQuestionView {
        let (sut, navigator) = makeSUT()
        sut.answer(for: singleAnswerQuestion, completion: answerCallback)
        return navigator.topSingleAnswerView!
    }
    
    private func makeMultipleAnswerQuestionView(
        answerCallback: @escaping ([String]) -> Void = { _ in }
    ) -> MultipleAnswerQuestionView {
        let (sut, navigator) = makeSUT()
        sut.answer(for: multipleAnswerQuestion, completion: answerCallback)
        return navigator.topMultipleAnswerView!
    }
    
    private func makeResults(
        playAgain: @escaping () -> Void = {}
    ) -> ResultsView {
        let (sut, navigator) = makeSUT(playAgain: playAgain)
        sut.didCompleteQuiz(with: correctAnswers)
        return navigator.topResultsView!
    }
    
}

private extension UINavigationController {
    
    var topSingleAnswerView: SingleAnswerQuestionView? {
        let top = topViewController as? UIHostingController<SingleAnswerQuestionView>
        return top?.rootView
    }
    
    var topMultipleAnswerView: MultipleAnswerQuestionView? {
        let top = topViewController as? UIHostingController<MultipleAnswerQuestionView>
        return top?.rootView
    }
    
    var topResultsView: ResultsView? {
        let top = topViewController as? UIHostingController<ResultsView>
        return top?.rootView
    }
    
}
