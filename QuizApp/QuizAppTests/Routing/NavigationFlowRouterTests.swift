//
//  NavigationFlowRouterTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 25.09.21.
//

import XCTest
import QuizCore

@testable import QuizApp

class NavigationFlowRouter  {
    
    private let navigator: UINavigationController
    private let factory: ViewControllerFactory
    
    init(
        navigator: UINavigationController,
        factory: ViewControllerFactory
    ) {
        self.navigator = navigator
        self.factory = factory
    }
    
    func answer(
        for question: Question<String>,
        completion: @escaping ([String]) -> Void
    ) {
        switch question {
        case .singleAnswer:
            let controller = factory.questionViewController(
                for: question,
                answerCallback: completion
            )
            navigator.setViewControllers([controller], animated: true)
        case .multipleAnswer:
            let controller = factory.questionViewController(
                for: question,
                answerCallback: { _ in }
            )
            navigator.setViewControllers([controller], animated: true)
        }
        
    }
    
}

class NavigationFlowRouterTests: XCTestCase {
    
    func test_answerForQuestion_showsQuestionController() {
        let vc1 = UIViewController()
        let question = singleAnswerQuestion
        
        let (sut, navigator, factory) = makeSUT()
        XCTAssertEqual(navigator.viewControllers.count, 0)
        
        factory.stub(for: question, with: vc1)
        sut.answer(for: question, completion: { _ in })
        
        XCTAssertEqual(navigator.viewControllers.count, 1)
        XCTAssertEqual(navigator.viewControllers.first, vc1)
    }
    
    func test_answerFor_singleAnswerQuestion_firesAnswerCallback() {
        let (sut, _, factory) = makeSUT()
        let question = singleAnswerQuestion
        
        var callbackWasFired = false
        sut.answer(for: question, completion: { _ in callbackWasFired = true })
        factory.fireCallback(for: question)
        
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_answerFor_multipleAnswerQuestion_doesNotFireAnswerCallback() {
        let (sut, _, factory) = makeSUT()
        let question = multipleAnswerQuestion
        
        var callbackWasFired = false
        sut.answer(for: question, completion: { _ in callbackWasFired = true })
        factory.fireCallback(for: question)
        
        XCTAssertFalse(callbackWasFired)
    }
    
    // MARK:- Helpers
    
    private let singleAnswerQuestion = Question.singleAnswer("Q1")
    private let multipleAnswerQuestion = Question.multipleAnswer("Q2")
    
    private func makeSUT() -> (
        NavigationFlowRouter,
        NonAnimatedNavigationController,
        ViewControllerFactoryStub
    ) {
        let navigationController = NonAnimatedNavigationController()
        let factory = ViewControllerFactoryStub()
        let sut = NavigationFlowRouter(
            navigator: navigationController,
            factory: factory
        )
        return (sut, navigationController, factory)
    }
    
    private class ViewControllerFactoryStub: ViewControllerFactory {
        
        private var stubbedQuestions = [Question<String>: UIViewController]()
        private var answerCallbacks = [Question<String>: ([String]) -> Void]()
        
        func questionViewController(
            for question: Question<String>,
            answerCallback: @escaping ([String]) -> Void
        ) -> UIViewController {
            answerCallbacks[question] = answerCallback
            let controller = stubbedQuestions[question] ?? UIViewController()
            return controller
        }
        
        func resultViewController(for userAnswers: Answers) -> UIViewController {
            return UIViewController()
        }
        
        func stub(
            for question: Question<String>,
            with viewController: UIViewController
        ) {
            stubbedQuestions[question] = viewController
        }
        
        func fireCallback(
            for question: Question<String>,
            with answers: [String] = []
        ) {
            answerCallbacks[question]?(answers)
        }
        
    }
    
}
