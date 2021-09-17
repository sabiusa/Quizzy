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
    
    let navigationController = NonAnimatedNavigationController()
    let factory = ViewControllerFactoryStub()
    
    func test_routeToQuestion_showsQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        factory.stub(question: Question.singleAnswer("Q1"), with: viewController)
        factory.stub(question: Question.singleAnswer("Q2"), with: secondViewController)
        
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        sut.route(to: Question.singleAnswer("Q1"), answerCallback: { _ in })
        sut.route(to: Question.singleAnswer("Q2"), answerCallback: { _ in })
        
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
        sut.route(to: Question.singleAnswer("Q1"), answerCallback: { _ in callbackWasFired = true })
        factory.fireCallback(for: Question.singleAnswer("Q1"))
        
        XCTAssertTrue(callbackWasFired)
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
        private var answerCallbacks = [Question<String>: (String) -> Void]()
        
        func questionViewController(
            for question: Question<String>,
            answerCallback: @escaping (String) -> Void
        ) -> UIViewController {
            answerCallbacks[question] = answerCallback
            let viewController = stubbedQuestions[question] ?? UIViewController()
            return viewController
        }
        
        func stub(
            question: Question<String>,
            with viewController: UIViewController
        ) {
            stubbedQuestions[question] = viewController
        }
        
        func fireCallback(
            for question: Question<String>,
            with answer: String = ""
        ) {
            answerCallbacks[question]?(answer)
        }
        
    }
    
}
