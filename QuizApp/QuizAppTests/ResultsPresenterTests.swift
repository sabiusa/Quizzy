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
    
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q2")
    
    func test_summary_withTwoQuestionsAnsScoreOne_returnsSummary() {
        let answers = [
            singleAnswerQuestion: ["A1"],
            multipleAnswerQuestion: ["A2", "A3"]
        ]
        let orderedQuestions = [singleAnswerQuestion, multipleAnswerQuestion]
        let result = QuizResult.make(answers: answers, score: 1)
        
        let sut = ResultsPresenter(
            questions: orderedQuestions,
            result: result,
            correctAnswers: [:]
        )
        
        XCTAssertEqual(sut.summary, "You go 1/2 correct")
    }
    
    func test_presentableAnswers_withoutQuestions_isEmpty() {
        let answers = [Question<String>: [String]]()
        let result = QuizResult.make(answers: answers, score: 0)
        
        let sut = ResultsPresenter(
            questions: [],
            result: result,
            correctAnswers: [:]
        )
        
        XCTAssertTrue(sut.presentableAnswers.isEmpty)
    }
    
    func test_presentableAnswers_withWrongSingleAnswer_mapsAnswer() {
        let userAnswers = [singleAnswerQuestion: ["A1"]]
        let correctAnswers = [singleAnswerQuestion: ["A2"]]
        let result = QuizResult.make(answers: userAnswers, score: 0)
        
        let sut = ResultsPresenter(
            questions: [singleAnswerQuestion],
            result: result,
            correctAnswers: correctAnswers
        )
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.correctAnswer, "A2")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1")
    }
    
    func test_presentableAnswers_withWrongMultipleAnswer_mapsAnswer() {
        let userAnswers = [multipleAnswerQuestion: ["A1", "A4"]]
        let correctAnswers = [multipleAnswerQuestion: ["A2", "A3"]]
        let result = QuizResult.make(answers: userAnswers, score: 0)
        
        let sut = ResultsPresenter(
            questions: [multipleAnswerQuestion],
            result: result,
            correctAnswers: correctAnswers
        )
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.first!.correctAnswer, "A2, A3")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1, A4")
    }
    
    func test_presentableAnswers_withTwoQuestions_mapsOrderedAnswer() {
        let userAnswers = [
            multipleAnswerQuestion: ["A3"],
            singleAnswerQuestion: ["A1", "A4"]
        ]
        let correctAnswers = [
            multipleAnswerQuestion: ["A3"],
            singleAnswerQuestion: ["A1", "A4"]
        ]
        let orderedQuestions = [
            singleAnswerQuestion,
            multipleAnswerQuestion
        ]
        let result = QuizResult.make(answers: userAnswers, score: 0)
        
        let sut = ResultsPresenter(
            questions: orderedQuestions,
            result: result,
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
    
}
