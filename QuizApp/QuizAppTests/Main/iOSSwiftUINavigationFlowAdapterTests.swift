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
    
    private let navigator: UINavigationController
    private let questions: [Question]
    private let options: [Question: Answer]
    
    init(
        navigator: UINavigationController,
        questions: [Question],
        options: [Question: Answer]
    ) {
        self.navigator = navigator
        self.questions = questions
        self.options = options
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
                selection: { _ in }
            )
            let host = UIHostingController(rootView: singleView)
            navigator.setViewControllers([host], animated: true)
        default:
            break
        }
    }
    
}

class iOSSwiftUINavigationFlowAdapterTests: XCTestCase {
    
    func test_answerFor_singleAnswer_createsControllerWithTitle() {
        let question = singleAnswerQuestion
        let presenter = QuestionPresenter(
            allQuestions: questions,
            currentQuestion: question
        )
        let navigator = NonAnimatedNavigationController()
        let sut = iOSSwiftUINavigationFlowAdapter(
            navigator: navigator,
            questions: questions,
            options: options
        )
        
        sut.answer(for: question, completion: { _ in })
        
        let host = navigator.topViewController as! UIHostingController<SingleAnswerQuestionView>
        let singleAnswerView = host.rootView
        
        XCTAssertEqual(singleAnswerView.title, presenter.title)
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
    
}
