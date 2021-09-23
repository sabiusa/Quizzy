//
//  ShowStrategyTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 23.09.21.
//

import XCTest

@testable import QuizApp

class ShowStrategyTests: XCTestCase {
    
    func test_pushStrategy_pushesToStack() {
        let navigation = NonAnimatedNavigationController()
        let sut = PushStrategy(navigationController: navigation)

        XCTAssertEqual(navigation.viewControllers.count, 0)

        sut.show(UIViewController())
        XCTAssertEqual(navigation.viewControllers.count, 1)

        sut.show(UIViewController())
        XCTAssertEqual(navigation.viewControllers.count, 2)
    }
    
}
