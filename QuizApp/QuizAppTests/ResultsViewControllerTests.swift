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
        let sut = makeSUT(summary: "summary")
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.headerLabel.text, "summary")
    }
    
    func test_viewDidLoad_rendersAnswers() {
        let sut1 = makeSUT(answers: [])
        sut1.loadViewIfNeeded()
        XCTAssertEqual(sut1.tableView.numberOfRows(inSection: 0), 0)
        
        let sut2 = makeSUT(answers: ["A1"])
        sut2.loadViewIfNeeded()
        XCTAssertEqual(sut2.tableView.numberOfRows(inSection: 0), 1)
    }
    
    // MARK:- Helpers
    
    func makeSUT(
        summary: String = "",
        answers: [String] = []
    ) -> ResultsViewController {
        let sut = ResultsViewController(
            summary: summary,
            answers: answers
        )
        return sut
    }
    
}
