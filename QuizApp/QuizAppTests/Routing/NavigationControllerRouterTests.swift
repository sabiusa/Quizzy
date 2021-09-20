//
//  NavigationControllerRouterTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 16.09.21.
//

import XCTest
import QuizCore

@testable import QuizApp

class NavigationControllerRouterTests: XCTestCase {
    
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q2")
    
    let navigationController = NonAnimatedNavigationController()
    let factory = ViewControllerFactoryStub()
    
    func test_routeToQuestion_showsQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        factory.stub(question: singleAnswerQuestion, with: viewController)
        factory.stub(question: multipleAnswerQuestion, with: secondViewController)
        
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        sut.route(to: singleAnswerQuestion, answerCallback: { _ in })
        sut.route(to: multipleAnswerQuestion, answerCallback: { _ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_singleAnswer_answerCallbackProgressesToNextQuestion() {
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        var callbackWasFired = false
        sut.route(
            to: singleAnswerQuestion,
            answerCallback: { _ in callbackWasFired = true }
        )
        factory.fireCallback(for: singleAnswerQuestion)
        
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_routeToQuestion_singleAnswer_doesNotConfigureViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: singleAnswerQuestion, with: viewController)
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        sut.route(to: singleAnswerQuestion, answerCallback: { _ in })
        
        XCTAssertNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_routeToQuestion_multipleAnswer_answerCallbackDoesNotProgressToNextQuestion() {
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        var callbackWasFired = false
        sut.route(
            to: multipleAnswerQuestion,
            answerCallback: { _ in callbackWasFired = true }
        )
        factory.fireCallback(for: multipleAnswerQuestion)
        
        XCTAssertFalse(callbackWasFired)
    }
    
    func test_routeToQuestion_multipleAnswer_configuresViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, with: viewController)
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        sut.route(to: multipleAnswerQuestion, answerCallback: { _ in })
        
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_routeToQuestion_multipleAnswer_submitButton_isDisabledWhenZeroAnswerSelected() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, with: viewController)
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        sut.route(to: multipleAnswerQuestion, answerCallback: { _ in })
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.fireCallback(for: multipleAnswerQuestion, with: ["A1"])
        XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.fireCallback(for: multipleAnswerQuestion, with: [])
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func test_routeToQuestion_multipleAnswer_submitButton_progressesToNextQuestion() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, with: viewController)
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        var callbackWasFired = false
        sut.route(to: multipleAnswerQuestion, answerCallback: { _ in
            callbackWasFired = true
        })
        factory.fireCallback(for: multipleAnswerQuestion, with: ["A1"])
        viewController.navigationItem.rightBarButtonItem?.simulateTap()
        
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_routeToResult_showsResultController() {
        let viewController = UIViewController()
        let result = QuizResult.make(
            answers: [singleAnswerQuestion: ["A1"]],
            score: 10
        )
        
        let secondViewController = UIViewController()
        let secondResult = QuizResult.make(
            answers: [multipleAnswerQuestion: ["A2"]],
            score: 20
        )
        
        factory.stub(result: result, with: viewController)
        factory.stub(result: secondResult, with: secondViewController)
        
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        sut.route(to: result)
        sut.route(to: secondResult)
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    // MARK:- Helpers
    
    class NonAnimatedNavigationController: UINavigationController {
        
        override func pushViewController(
            _ viewController: UIViewController,
            animated: Bool
        ) {
            super.pushViewController(viewController, animated: false)
        }
        
    }
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        
        private var stubbedQuestions = [Question<String>: UIViewController]()
        private var stubbedResults = [QuizResult<Question<String>, [String]>: UIViewController]()
        private var answerCallbacks = [Question<String>: ([String]) -> Void]()
        
        func questionViewController(
            for question: Question<String>,
            answerCallback: @escaping ([String]) -> Void
        ) -> UIViewController {
            answerCallbacks[question] = answerCallback
            let viewController = stubbedQuestions[question] ?? UIViewController()
            return viewController
        }
        
        func resultViewController(
            for result: QuizResult<Question<String>, [String]>
        ) -> UIViewController {
            return stubbedResults[result] ?? UIViewController()
        }
        
        func stub(
            question: Question<String>,
            with viewController: UIViewController
        ) {
            stubbedQuestions[question] = viewController
        }
        
        func stub(
            result: QuizResult<Question<String>, [String]>,
            with viewController: UIViewController
        ) {
            stubbedResults[result] = viewController
        }
        
        func fireCallback(
            for question: Question<String>,
            with answers: [String] = []
        ) {
            answerCallbacks[question]?(answers)
        }
        
    }
    
}

private extension UIBarButtonItem {
    
    func simulateTap() {
        target?.performSelector(
            onMainThread: action!,
            with: nil,
            waitUntilDone: true
        )
    }
    
}
