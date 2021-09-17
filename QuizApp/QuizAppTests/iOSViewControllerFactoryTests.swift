//
//  iOSViewControllerFactoryTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 17.09.21.
//

import XCTest

@testable import QuizApp

class iOSViewControllerFactoryTests: XCTestCase {
    
    func test_questionViewController_createsController() {
        let sut = iOSViewControllerFactory()
        
        let controller = sut.questionViewController(
            for: Question.singleAnswer("Q1"),
            answerCallback: { _ in }
        ) as? QuestionViewController
        
        XCTAssertNotNil(controller)
    }
    
}
