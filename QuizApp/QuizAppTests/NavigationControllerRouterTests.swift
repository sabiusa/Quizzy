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
        let sut = NavigationControllerRouter(navigationController)
        
        sut.route(to: "Q1", answerCallback: { _ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }
    
}
