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
    
    func test_viewDidLoad_withCorrectAnswer_configuresCell() {
        let answer = makeAnswer(question: "Q1", correctAnswer: "A1")
        let sut = makeSUT(answers: [answer])
        sut.loadViewIfNeeded()

        let cell = sut.tableView.cell(at: 0) as? CorrectAnswerCell

        XCTAssertNotNil(cell, "Expected `CorrectAnswerCell`")
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
        XCTAssertEqual(cell?.answerLabel.text, "A1")
    }
    
    func test_viewDidLoad_withWrongAnswer_configuresCell() {
        let answer = makeAnswer(
            question: "Q1",
            correctAnswer: "A1",
            wrongAnswer: "A2"
        )
        let sut = makeSUT(answers: [answer])
        sut.loadViewIfNeeded()

        let cell = sut.tableView.cell(at: 0) as? WrongAnswerCell

        XCTAssertNotNil(cell, "Expected `WrongAnswerCell`")
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
        XCTAssertEqual(cell?.correctAnswerLabel.text, "A1")
        XCTAssertEqual(cell?.wrongAnswerLabel.text, "A2")
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
    
    func makeAnswer(
        question: String = "",
        correctAnswer: String = "",
        wrongAnswer: String? = nil
    ) -> PresentableAnswer {
        return PresentableAnswer(
            question: question,
            correctAnswer: correctAnswer,
            wrongAnswer: wrongAnswer
        )
    }
    
}
