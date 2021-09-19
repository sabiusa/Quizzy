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
        let sut = makeSUT(question: "Q1")
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.headerLabel.text, "Q1")
    }
    
    func test_viewDidLoad_rendersCorrectNumberOfOptions() {
        let sut1 = makeSUT(question: "Q1", options: [])
        sut1.loadViewIfNeeded()
        XCTAssertEqual(sut1.tableView.numberOfRows(inSection: 0), 0)
        
        let sut2 = makeSUT(question: "Q1", options: ["A1", "A2"])
        sut2.loadViewIfNeeded()
        XCTAssertEqual(sut2.tableView.numberOfRows(inSection: 0), 2)
    }
    
    func test_viewDidLoad_withOneOption_rendersOptionsText() {
        let sut = makeSUT(question: "Q1", options: ["A1", "A2"])
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.tableView.title(at: 0), "A1")
        XCTAssertEqual(sut.tableView.title(at: 1), "A2")
    }
    
    func test_viewDidLoad_withSingleSelection_configuresTableViewSelection() {
        let sut = makeSUT(
            question: "Q1",
            options: ["A1", "A2"],
            isMultipleSelection: false
        )
        
        sut.loadViewIfNeeded()
        
        XCTAssertFalse(sut.tableView.allowsMultipleSelection)
    }
    
    func test_viewDidLoad_withMultipleSelection_configuresTableViewSelection() {
        let sut = makeSUT(
            question: "Q1",
            options: ["A1", "A2"],
            isMultipleSelection: true
        )
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.tableView.allowsMultipleSelection)
    }
    
    func test_optionSelected_withSingleSelection_notifiesDelegateWithLastSelection() {
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"], isMultipleSelection: false) {
            receivedAnswer = $0
        }
        sut.loadViewIfNeeded()
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        sut.tableView.select(row: 1)
        XCTAssertEqual(receivedAnswer, ["A2"])
    }
    
    func test_optionDeselected_withSingleSelection_doesNotNotifyDelegateWithEmptySelection() {
        var callbackCount = 0
        let sut = makeSUT(options: ["A1", "A2"], isMultipleSelection: false) { _ in
            callbackCount += 1
        }
        sut.loadViewIfNeeded()
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(callbackCount, 1)
        
        sut.tableView.deselect(row: 0)
        XCTAssertEqual(callbackCount, 1)
    }
    
    func test_optionSelected_withMultipleSelectionEnabled_notifiesDelegateWithSelections() {
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"], isMultipleSelection: true) {
            receivedAnswer = $0
        }
        sut.loadViewIfNeeded()
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        sut.tableView.select(row: 1)
        XCTAssertEqual(receivedAnswer, ["A1", "A2"])
    }
    
    func test_optionDeselected_withMultipleSelectionEnabled_notifiesDelegate() {
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"], isMultipleSelection: true) {
            receivedAnswer = $0
        }
        sut.loadViewIfNeeded()
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        sut.tableView.deselect(row: 0)
        XCTAssertEqual(receivedAnswer, [])
    }
    
    // MARK:- Helpers
    
    func makeSUT(
        question: String = "",
        options: [String] = [],
        isMultipleSelection: Bool = false,
        selection: @escaping (([String]) -> Void) = { _ in }
    ) -> QuestionViewController {
        let sut = QuestionViewController(
            question: question,
            options: options,
            selection: selection
        )
        sut.loadViewIfNeeded()
        sut.tableView.allowsMultipleSelection = isMultipleSelection
        return sut
    }
    
}
