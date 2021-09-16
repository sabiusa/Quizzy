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
        let sut = ResultsViewController(summary: "summary")
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.headerLabel.text, "summary")
    }
    
}
