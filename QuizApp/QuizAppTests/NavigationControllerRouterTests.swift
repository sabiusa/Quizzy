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
    
    let navigationController = UINavigationController()
    let factory = ViewControllerFactoryStub()
    
    func test_routeToQuestion_showsQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        factory.stub(question: "Q1", with: viewController)
        factory.stub(question: "Q2", with: secondViewController)
        
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        sut.route(to: "Q1", answerCallback: { _ in })
        sut.route(to: "Q2", answerCallback: { _ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_presentsQuestionControllerWithRightCallback() {
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        var callbackWasFired = false
        sut.route(to: "Q1", answerCallback: { _ in callbackWasFired = true })
        factory.fireCallback(for: "Q1")
        
        XCTAssertTrue(callbackWasFired)
    }
    
    // MARK:- Helpers
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        
        private var stubbedQuestions = [String: UIViewController]()
        private var answerCallbacks = [String: (String) -> Void]()
        
        func questionViewController(
            for question: String,
            answerCallback: @escaping (String) -> Void
        ) -> UIViewController {
            answerCallbacks[question] = answerCallback
            let viewController = stubbedQuestions[question] ?? UIViewController()
            return viewController
        }
        
        func stub(
            question: String,
            with viewController: UIViewController
        ) {
            stubbedQuestions[question] = viewController
        }
        
        func fireCallback(
            for question: String,
            with answer: String = ""
        ) {
            answerCallbacks[question]?(answer)
        }
        
    }
    
}
