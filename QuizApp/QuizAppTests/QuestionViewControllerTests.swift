//
//  QuestionViewControllerTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 15.09.21.
//

import Foundation
import XCTest

@testable import QuizApp

class QuestionViewControllerTests: XCTestCase {
    
    func test_viewDidLoad_rendersQuestionHeaderText() {
        let sut = QuestionViewController(question: "Q1", options: [])
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.headerLabel.text, "Q1")
    }
    
    func test_viewDidLoad_withNoOptions_rendersZeroOptions() {
        let sut = QuestionViewController(question: "Q1", options: [])
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)
    }
    
}
