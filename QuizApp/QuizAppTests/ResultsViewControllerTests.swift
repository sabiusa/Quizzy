//
//  ResultsViewControllerTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 16.09.21.
//

import Foundation
import XCTest

@testable import QuizApp

class ResultsViewControllerTests: XCTestCase {
    
    func test_viewDidLoad_rendersSummary() {
        let sut = ResultsViewController(summary: "summary", answers: [])
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.headerLabel.text, "summary")
    }
    
    func test_viewDidLoad_withoutAnswers_doesNotRenderAnswers() {
        let sut = ResultsViewController(summary: "summary", answers: [])
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)
    }
    
}
