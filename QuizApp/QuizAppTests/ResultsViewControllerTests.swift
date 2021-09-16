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
        
        let sut2 = makeSUT(answers: [makeAnswer()])
        sut2.loadViewIfNeeded()
        XCTAssertEqual(sut2.tableView.numberOfRows(inSection: 0), 1)
    }
    
    func test_viewDidLoad_withCorrectAnswer_rendersCorrectAnswerCell() {
        let sut = makeSUT(answers: [PresentableAnswer(isCorrect: true)])
        sut.loadViewIfNeeded()
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath) as? CorrectAnswerCell
        
        XCTAssertNotNil(cell)
    }
    
    // MARK:- Helpers
    
    func makeSUT(
        summary: String = "",
        answers: [PresentableAnswer] = []
    ) -> ResultsViewController {
        let sut = ResultsViewController(
            summary: summary,
            answers: answers
        )
        return sut
    }
    
    func makeAnswer() -> PresentableAnswer {
        return PresentableAnswer(isCorrect: false)
    }
    
}
