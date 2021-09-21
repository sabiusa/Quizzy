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
    
    func test_answerForQuestion_showsQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        factory.stub(question: singleAnswerQuestion, with: viewController)
        factory.stub(question: multipleAnswerQuestion, with: secondViewController)
        
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        sut.answer(for: singleAnswerQuestion, completion: { _ in })
        sut.answer(for: multipleAnswerQuestion, completion: { _ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_answerForQuestion_singleAnswer_answerCallbackProgressesToNextQuestion() {
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        var callbackWasFired = false
        sut.answer(
            for: singleAnswerQuestion,
            completion: { _ in callbackWasFired = true }
        )
        factory.fireCallback(for: singleAnswerQuestion)
        
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_answerForQuestion_singleAnswer_doesNotConfigureViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: singleAnswerQuestion, with: viewController)
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        sut.answer(for: singleAnswerQuestion, completion: { _ in })
        
        XCTAssertNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_answerForQuestion_multipleAnswer_answerCallbackDoesNotProgressToNextQuestion() {
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        var callbackWasFired = false
        sut.answer(
            for: multipleAnswerQuestion,
            completion: { _ in callbackWasFired = true }
        )
        factory.fireCallback(for: multipleAnswerQuestion)
        
        XCTAssertFalse(callbackWasFired)
    }
    
    func test_answerForQuestion_multipleAnswer_configuresViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, with: viewController)
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        sut.answer(for: multipleAnswerQuestion, completion: { _ in })
        
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_answerForQuestion_multipleAnswer_submitButton_isDisabledWhenZeroAnswerSelected() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, with: viewController)
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        sut.answer(for: multipleAnswerQuestion, completion: { _ in })
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.fireCallback(for: multipleAnswerQuestion, with: ["A1"])
        XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.fireCallback(for: multipleAnswerQuestion, with: [])
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func test_answerForQuestion_multipleAnswer_submitButton_progressesToNextQuestion() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, with: viewController)
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        var callbackWasFired = false
        sut.answer(for: multipleAnswerQuestion, completion: { _ in
            callbackWasFired = true
        })
        factory.fireCallback(for: multipleAnswerQuestion, with: ["A1"])
        viewController.navigationItem.rightBarButtonItem?.simulateTap()
        
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_didCompleteQuiz_showsResultController() {
        let viewController = UIViewController()
        let userAnswers = [(singleAnswerQuestion, ["A1"])]
        
        let secondViewController = UIViewController()
        let secondUserAnswers = [(multipleAnswerQuestion, ["A2"])]
        
        factory.stub(resultForQuestions: [singleAnswerQuestion], with: viewController)
        factory.stub(resultForQuestions: [multipleAnswerQuestion], with: secondViewController)
        
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        sut.didCompleteQuiz(with: userAnswers)
        sut.didCompleteQuiz(with: secondUserAnswers)
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    // MARK:- Helpers
    
    private let singleAnswerQuestion = Question.singleAnswer("Q1")
    private let multipleAnswerQuestion = Question.multipleAnswer("Q2")
    
    private let navigationController = NonAnimatedNavigationController()
    private let factory = ViewControllerFactoryStub()
    
    private class NonAnimatedNavigationController: UINavigationController {
        
        override func pushViewController(
            _ viewController: UIViewController,
            animated: Bool
        ) {
            super.pushViewController(viewController, animated: false)
        }
        
    }
    
    private class ViewControllerFactoryStub: ViewControllerFactory {
        
        private var stubbedQuestions = [Question<String>: UIViewController]()
        private var stubbedResults = [[Question<String>]: UIViewController]()
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
            return UIViewController()
        }
        
        func resultViewController(for userAnswers: Answers) -> UIViewController {
            return stubbedResults[userAnswers.map(\.question)] ??  UIViewController()
        }
        
        func stub(
            question: Question<String>,
            with viewController: UIViewController
        ) {
            stubbedQuestions[question] = viewController
        }
        
        func stub(
            resultForQuestions questions: [Question<String>],
            with viewController: UIViewController
        ) {
            stubbedResults[questions] = viewController
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
