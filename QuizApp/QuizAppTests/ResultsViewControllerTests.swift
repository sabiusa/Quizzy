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
        
        let sut2 = makeSUT(answers: [makeAnswer(isCorrect: false)])
        sut2.loadViewIfNeeded()
        XCTAssertEqual(sut2.tableView.numberOfRows(inSection: 0), 1)
    }
    
    func test_viewDidLoad_withCorrectAnswer_rendersCorrectAnswerCell() {
        let sut = makeSUT(answers: [makeAnswer(isCorrect: true)])
        sut.loadViewIfNeeded()
        
        let cell = sut.tableView.cell(at: 0) as? CorrectAnswerCell
        
        XCTAssertNotNil(cell)
    }
    
    func test_viewDidLoad_withCorrectAnswer_rendersQuestionText() {
        let answer = makeAnswer(question: "Q1", isCorrect: true)
        let sut = makeSUT(answers: [answer])
        sut.loadViewIfNeeded()

        let cell = sut.tableView.cell(at: 0) as! CorrectAnswerCell

        XCTAssertEqual(cell.questionLabel.text, "Q1")
    }
    
    func test_viewDidLoad_withCorrectAnswer_rendersAnswerText() {
        let answer = makeAnswer(answer: "A1", isCorrect: true)
        let sut = makeSUT(answers: [answer])
        sut.loadViewIfNeeded()

        let cell = sut.tableView.cell(at: 0) as! CorrectAnswerCell

        XCTAssertEqual(cell.answerLabel.text, "A1")
    }
    
    func test_viewDidLoad_withWrongAnswer_rendersWrongAnswerCell() {
        let sut = makeSUT(answers: [makeAnswer(isCorrect: false)])
        sut.loadViewIfNeeded()
        
        let cell = sut.tableView.cell(at: 0) as? WrongAnswerCell
        
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
    
    func makeAnswer(
        question: String = "",
        answer: String = "",
        isCorrect: Bool
    ) -> PresentableAnswer {
        return PresentableAnswer(
            question: question,
            answer: answer,
            isCorrect: isCorrect
        )
    }
    
}
