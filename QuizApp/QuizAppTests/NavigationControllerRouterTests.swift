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
    
    func test_routeToQuestion_presentsQuestionController() {
        let navigationController = UINavigationController()
        let factory = ViewControllerFactoryStub()
        let viewController = UIViewController()
        factory.stub(question: "Q1", with: viewController)
        
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        sut.route(to: "Q1", answerCallback: { _ in })
        
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
    }
    
    // MARK:- Helpers
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        
        private var stubbedQuestions = [String: UIViewController]()
        
        func stub(
            question: String,
            with viewController: UIViewController
        ) {
            stubbedQuestions[question] = viewController
        }
        
        func questionViewController(
            for question: String,
            answerCallback: (String) -> Void
        ) -> UIViewController {
            return stubbedQuestions[question]!
        }
        
    }
    
}
