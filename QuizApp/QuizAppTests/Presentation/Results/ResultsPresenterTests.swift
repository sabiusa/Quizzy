//
//  ResultsPresenterTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 19.09.21.
//

import XCTest
import QuizCore

@testable import QuizApp

class ResultsPresenterTests: XCTestCase {
    
    func test_title_returnsFormattedTitle() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.title, "Result")
    }
    
    func test_summary_withTwoQuestionsAnsScoreOne_returnsSummary() {
        let userAnswers = [
            (singleAnswerQuestion, ["A1"]),
            (multipleAnswerQuestion, ["A2", "A3"])
        ]
        let correctAnswers = [
            (singleAnswerQuestion, ["A1"]),
            (multipleAnswerQuestion, ["A2"])
        ]
        
        let sut = makeSUT(
            userAnswers: userAnswers,
            correctAnswers: correctAnswers,
            score: 1
        )

        XCTAssertEqual(sut.summary, "You got 1/2 correct")
    }
    
    func test_presentableAnswers_withoutQuestions_isEmpty() {
        let sut = makeSUT(userAnswers: [], correctAnswers: [])
        
        XCTAssertTrue(sut.presentableAnswers.isEmpty)
    }
    
    func test_presentableAnswers_withWrongSingleAnswer_mapsAnswer() {
        let userAnswers = [(singleAnswerQuestion, ["A1"])]
        let correctAnswers = [(singleAnswerQuestion, ["A2"])]
        
        let sut = makeSUT(
            userAnswers: userAnswers,
            correctAnswers: correctAnswers,
            score: 0
        )
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.correctAnswer, "A2")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1")
    }
    
    func test_presentableAnswers_withWrongMultipleAnswer_mapsAnswer() {
        let userAnswers = [(multipleAnswerQuestion, ["A1", "A4"])]
        let correctAnswers = [(multipleAnswerQuestion, ["A2", "A3"])]
        
        let sut = makeSUT(
            userAnswers: userAnswers,
            correctAnswers: correctAnswers,
            score: 0
        )
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.first!.correctAnswer, "A2, A3")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1, A4")
    }
    
    func test_presentableAnswers_withTwoQuestions_mapsOrderedAnswer() {
        let userAnswers = [
            (singleAnswerQuestion, ["A1", "A4"]),
            (multipleAnswerQuestion, ["A3"])
        ]
        let correctAnswers = [
            (singleAnswerQuestion, ["A1", "A4"]),
            (multipleAnswerQuestion, ["A3"])
        ]
        
        let sut = makeSUT(
            userAnswers: userAnswers,
            correctAnswers: correctAnswers
        )
        
        XCTAssertEqual(sut.presentableAnswers.count, 2)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.correctAnswer, "A1, A4")
        XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)
        
        XCTAssertEqual(sut.presentableAnswers.last!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.last!.correctAnswer, "A3")
        XCTAssertNil(sut.presentableAnswers.last!.wrongAnswer)
    }
    
    // MARK:- Helpers
    
    private let singleAnswerQuestion = Question.singleAnswer("Q1")
    private let multipleAnswerQuestion = Question.multipleAnswer("Q2")
    
    private func makeSUT(
        userAnswers: ResultsPresenter.Answers = [],
        correctAnswers: ResultsPresenter.Answers = [],
        score: Int = 0
    ) -> ResultsPresenter {
        let sut = ResultsPresenter(
            userAnswers: userAnswers,
            correctAnswers: correctAnswers,
            scorer: { _, _ in score }
        )
        return sut
    }
    
}
