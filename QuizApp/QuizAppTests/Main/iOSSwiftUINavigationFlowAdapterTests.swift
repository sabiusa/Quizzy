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

class iOSSwiftUINavigationFlowAdapter {
    
    typealias Question = QuizCore.Question<String>
    typealias Answer = [String]
    typealias Answers = [(question: Question, answer: Answer)]
    
    private let navigator: UINavigationController
    private let questions: [Question]
    private let options: [Question: Answer]
    private let correctAnswers: Answers
    private let playAgain: () -> Void
    
    init(
        navigator: UINavigationController,
        questions: [Question],
        options: [Question: Answer],
        correctAnswers: Answers,
        playAgain: @escaping () -> Void
    ) {
        self.navigator = navigator
        self.questions = questions
        self.options = options
        self.correctAnswers = correctAnswers
        self.playAgain = playAgain
    }
    
    func answer(
        for question: Question,
        completion: @escaping (Answer) -> Void
    ) {
        guard let options = options[question] else {
            fatalError("Options not found for question: \(question)")
        }
        
        let presenter = QuestionPresenter(
            allQuestions: questions,
            currentQuestion: question
        )
        
        switch question {
        case .singleAnswer(let text):
            let singleView = SingleAnswerQuestionView(
                title: presenter.title,
                question: text,
                options: options,
                selection: { selection in
                    completion([selection])
                }
            )
            let host = UIHostingController(rootView: singleView)
            navigator.setViewControllers([host], animated: true)
        case .multipleAnswer(let text):
            let multipleView = MultipleAnswerQuestionView(
                title: presenter.title,
                question: text,
                store: MultipleSelectionStore(
                    options: options,
                    handler: { _ in }
                )
            )
            let host = UIHostingController(rootView: multipleView)
            navigator.setViewControllers([host], animated: true)
        }
    }
    
    func didCompleteQuiz(with answers: Answers) {
        let presenter = ResultsPresenter(
            userAnswers: answers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score
        )
        
        let resultsView = ResultsView(
            title: presenter.title,
            summary: presenter.summary,
            answers: presenter.presentableAnswers,
            playAgain: playAgain
        )
        let host = UIHostingController(rootView: resultsView)
        navigator.setViewControllers([host], animated: true)
    }
    
}

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
        let host = navigator.topViewController as! UIHostingController<SingleAnswerQuestionView>
        return host.rootView
    }
    
    private func makeMultipleAnswerQuestionView(
        answerCallback: @escaping ([String]) -> Void = { _ in }
    ) -> MultipleAnswerQuestionView {
        let (sut, navigator) = makeSUT()
        sut.answer(for: multipleAnswerQuestion, completion: answerCallback)
        let host = navigator.topViewController as! UIHostingController<MultipleAnswerQuestionView>
        return host.rootView
    }
    
    private func makeResults(
        playAgain: @escaping () -> Void = {}
    ) -> ResultsView {
        let (sut, navigator) = makeSUT(playAgain: playAgain)
        sut.didCompleteQuiz(with: correctAnswers)
        let host = navigator.topViewController as! UIHostingController<ResultsView>
        return host.rootView
    }
    
}
