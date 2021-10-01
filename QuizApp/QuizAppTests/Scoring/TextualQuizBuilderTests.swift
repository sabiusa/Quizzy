//
//  TextualQuizBuilderTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 28.09.21.
//

import XCTest
import QuizCore
import QuizApp

class TextualQuizBuilderTests: XCTestCase {
    
    func test_initWithSingleAnswerQuestion() throws {
        let sut = try TextualQuizBuilder(
            singleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answer: "O1"
        )
        
        let quiz = sut.build()
        
        XCTAssertEqual(quiz.questions, [.singleAnswer("Q1")])
        XCTAssertEqual(quiz.options, [.singleAnswer("Q1"): ["O1", "O2", "O3"]])
        assertEqual(quiz.correctAnswers, [(.singleAnswer("Q1"), ["O1"])])
    }
    
    func test_initWithSingleAnswerQuestion_duplicateOptions_throws() throws {
        assert(
            try TextualQuizBuilder(
                singleAnswerQuestion: "Q1",
                options: NonEmptyOptions(head: "O1", tail: ["O1", "O3"]),
                answer: "O1"
            ),
            throws: .duplicateOptions(["O1", "O1", "O3"])
        )
    }
    
    func test_initWithSingleAnswerQuestion_missingAnswerInOptions_throws() throws {
        assert(
            try TextualQuizBuilder(
                singleAnswerQuestion: "Q1",
                options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
                answer: "O4"
            ),
            throws: .missingAnswerInOptions(
                answer: ["O4"],
                options: ["O1", "O2", "O3"]
            )
        )
    }
    
    func test_addSingleAnswerQuestion() throws {
        var sut = try TextualQuizBuilder(
            singleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answer: "O1"
        )
        
        try sut.add(
            singleAnswerQuestion: "Q2",
            options: NonEmptyOptions(head: "O4", tail: ["O5", "O6"]),
            answer: "O4"
        )
        
        let quiz = sut.build()
        
        XCTAssertEqual(quiz.questions, [
            .singleAnswer("Q1"),
            .singleAnswer("Q2")
        ])
        XCTAssertEqual(quiz.options, [
            .singleAnswer("Q1"): ["O1", "O2", "O3"],
            .singleAnswer("Q2"): ["O4", "O5", "O6"]
        ])
        assertEqual(quiz.correctAnswers, [
            (.singleAnswer("Q1"), ["O1"]),
            (.singleAnswer("Q2"), ["O4"]),
        ])
    }
    
    func test_addSingleAnswerQuestion_duplicateQuestion_throws() throws {
        var sut = try TextualQuizBuilder(
            singleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answer: "O1"
        )
        
        assert(
            try sut.add(
                singleAnswerQuestion: "Q1",
                options: NonEmptyOptions(head: "O1", tail: ["O3", "O6"]),
                answer: "O1"
            ),
            throws: .duplicateQuestion(.singleAnswer("Q1"))
        )
    }
    
    func test_addSingleAnswerQuestion_duplicateOptions_throws() throws {
        var sut = try TextualQuizBuilder(
            singleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answer: "O1"
        )
        
        assert(
            try sut.add(
                singleAnswerQuestion: "Q2",
                options: NonEmptyOptions(head: "O4", tail: ["O4", "O6"]),
                answer: "O4"
            ),
            throws: .duplicateOptions(["O4", "O4", "O6"])
        )
    }
    
    func test_addSingleAnswerQuestion_missingAnswerInOptions_throws() throws {
        var sut = try TextualQuizBuilder(
            singleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answer: "O1"
        )
        
        assert(
            try sut.add(
                singleAnswerQuestion: "Q2",
                options: NonEmptyOptions(head: "O4", tail: ["O5", "O6"]),
                answer: "O7"
            ),
            throws: .missingAnswerInOptions(
                answer: ["O7"],
                options: ["O4", "O5", "O6"]
            )
        )
    }
    
    func test_addingSingleAnswerQuestion() throws {
        let sut = try TextualQuizBuilder(
            singleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answer: "O1"
        ).adding(
            singleAnswerQuestion: "Q2",
            options: NonEmptyOptions(head: "O4", tail: ["O5", "O6"]),
            answer: "O4"
        )
        
        let quiz = sut.build()
        
        XCTAssertEqual(quiz.questions, [
            .singleAnswer("Q1"),
            .singleAnswer("Q2")
        ])
        XCTAssertEqual(quiz.options, [
            .singleAnswer("Q1"): ["O1", "O2", "O3"],
            .singleAnswer("Q2"): ["O4", "O5", "O6"]
        ])
        assertEqual(quiz.correctAnswers, [
            (.singleAnswer("Q1"), ["O1"]),
            (.singleAnswer("Q2"), ["O4"]),
        ])
    }
    
    func test_addingSingleAnswerQuestion_duplicateQuestion_throws() throws {
        let sut = try TextualQuizBuilder(
            singleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answer: "O1"
        )
        
        assert(
            try sut.adding(
                singleAnswerQuestion: "Q1",
                options: NonEmptyOptions(head: "O1", tail: ["O3", "O6"]),
                answer: "O1"
            ),
            throws: .duplicateQuestion(.singleAnswer("Q1"))
        )
    }
    
    func test_addingSingleAnswerQuestion_duplicateOptions_throws() throws {
        let sut = try TextualQuizBuilder(
            singleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answer: "O1"
        )
        
        assert(
            try sut.adding(
                singleAnswerQuestion: "Q2",
                options: NonEmptyOptions(head: "O4", tail: ["O4", "O6"]),
                answer: "O4"
            ),
            throws: .duplicateOptions(["O4", "O4", "O6"])
        )
    }
    
    func test_addingSingleAnswerQuestion_missingAnswerInOptions_throws() throws {
        let sut = try TextualQuizBuilder(
            singleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answer: "O1"
        )
        
        assert(
            try sut.adding(
                singleAnswerQuestion: "Q2",
                options: NonEmptyOptions(head: "O4", tail: ["O5", "O6"]),
                answer: "O7"
            ),
            throws: .missingAnswerInOptions(
                answer: ["O7"],
                options: ["O4", "O5", "O6"]
            )
        )
    }
    
    func test_initWithMultipleAnswerQuestion() throws {
        let sut = try TextualQuizBuilder(
            multipleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answers: NonEmptyOptions(head: "O1", tail: ["O3"])
        )
        
        let quiz = sut.build()
        
        XCTAssertEqual(quiz.questions, [.multipleAnswer("Q1")])
        XCTAssertEqual(quiz.options, [.multipleAnswer("Q1"): ["O1", "O2", "O3"]])
        assertEqual(quiz.correctAnswers, [(.multipleAnswer("Q1"), ["O1", "O3"])])
    }
    
    func test_initWithMultipleAnswerQuestion_duplicateOptions_throws() throws {
        assert(
            try TextualQuizBuilder(
                multipleAnswerQuestion: "Q1",
                options: NonEmptyOptions(head: "O1", tail: ["O1", "O3"]),
                answers: NonEmptyOptions(head: "O1", tail: ["O3"])
            ),
            throws: .duplicateOptions(["O1", "O1", "O3"])
        )
    }
    
    func test_initWithMultipleAnswerQuestion_duplicateAnswers_throws() throws {
        assert(
            try TextualQuizBuilder(
                multipleAnswerQuestion: "Q1",
                options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
                answers: NonEmptyOptions(head: "O1", tail: ["O1"])
            ),
            throws: .duplicateAnswers(["O1", "O1"])
        )
    }
    
    func test_initWithMultipleAnswerQuestion_missingAnswersInOptions_throws() throws {
        assert(
            try TextualQuizBuilder(
                multipleAnswerQuestion: "Q1",
                options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
                answers: NonEmptyOptions(head: "O1", tail: ["O4"])
            ),
            throws: .missingAnswerInOptions(
                answer: ["O1", "O4"],
                options: ["O1", "O2", "O3"]
            )
        )
    }
    
    func test_addMultipleAnswerQuestion() throws {
        var sut = try TextualQuizBuilder(
            multipleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answers: NonEmptyOptions(head: "O1", tail: ["O3"])
        )
        
        try sut.add(
            multipleAnswerQuestion: "Q2",
            options: NonEmptyOptions(head: "O4", tail: ["O5", "O6"]),
            answers: NonEmptyOptions(head: "O4", tail: ["O5"])
        )
        
        let quiz = sut.build()
        
        XCTAssertEqual(quiz.questions, [
            .multipleAnswer("Q1"),
            .multipleAnswer("Q2")
        ])
        XCTAssertEqual(quiz.options, [
            .multipleAnswer("Q1"): ["O1", "O2", "O3"],
            .multipleAnswer("Q2"): ["O4", "O5", "O6"]
        ])
        assertEqual(quiz.correctAnswers, [
            (.multipleAnswer("Q1"), ["O1", "O3"]),
            (.multipleAnswer("Q2"), ["O4", "O5"]),
        ])
    }
    
    func test_addMultipleAnswerQuestion_duplicateQuestions_throws() throws {
        var sut = try TextualQuizBuilder(
            multipleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answers: NonEmptyOptions(head: "O1", tail: ["O3"])
        )
        
        assert(
            try sut.add(
                multipleAnswerQuestion: "Q1",
                options: NonEmptyOptions(head: "O4", tail: ["O5", "O6"]),
                answers: NonEmptyOptions(head: "O4", tail: ["O5"])
            ),
            throws: .duplicateQuestion(.multipleAnswer("Q1"))
        )
    }
    
    func test_addMultipleAnswerQuestion_duplicateOptions_throws() throws {
        var sut = try TextualQuizBuilder(
            multipleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answers: NonEmptyOptions(head: "O1", tail: ["O3"])
        )
        
        assert(
            try sut.add(
                multipleAnswerQuestion: "Q2",
                options: NonEmptyOptions(head: "O4", tail: ["O4", "O5"]),
                answers: NonEmptyOptions(head: "O4", tail: ["O5"])
            ),
            throws: .duplicateOptions(["O4", "O4", "O5"])
        )
    }
    
    func test_addMultipleAnswerQuestion_duplicateAnswers_throws() throws {
        var sut = try TextualQuizBuilder(
            multipleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answers: NonEmptyOptions(head: "O1", tail: ["O3"])
        )
        
        assert(
            try sut.add(
                multipleAnswerQuestion: "Q2",
                options: NonEmptyOptions(head: "O4", tail: ["O5", "O6"]),
                answers: NonEmptyOptions(head: "O4", tail: ["O4"])
            ),
            throws: .duplicateAnswers(["O4", "O4"])
        )
    }
    
    func test_addMultipleAnswerQuestion_missingAnswersInOptions_throws() throws {
        var sut = try TextualQuizBuilder(
            multipleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answers: NonEmptyOptions(head: "O1", tail: ["O3"])
        )
        
        assert(
            try sut.add(
                multipleAnswerQuestion: "Q2",
                options: NonEmptyOptions(head: "O4", tail: ["O5", "O6"]),
                answers: NonEmptyOptions(head: "O4", tail: ["O8"])
            ),
            throws: .missingAnswerInOptions(
                answer: ["O4", "O8"],
                options: ["O4", "O5", "O6"]
            )
        )
    }
    
    func test_addingMultipleAnswerQuestion() throws {
        let sut = try TextualQuizBuilder(
            multipleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answers: NonEmptyOptions(head: "O1", tail: ["O3"])
        ).adding(
            multipleAnswerQuestion: "Q2",
            options: NonEmptyOptions(head: "O4", tail: ["O5", "O6"]),
            answers: NonEmptyOptions(head: "O4", tail: ["O5"])
        )
        
        let quiz = sut.build()
        
        XCTAssertEqual(quiz.questions, [
            .multipleAnswer("Q1"),
            .multipleAnswer("Q2")
        ])
        XCTAssertEqual(quiz.options, [
            .multipleAnswer("Q1"): ["O1", "O2", "O3"],
            .multipleAnswer("Q2"): ["O4", "O5", "O6"]
        ])
        assertEqual(quiz.correctAnswers, [
            (.multipleAnswer("Q1"), ["O1", "O3"]),
            (.multipleAnswer("Q2"), ["O4", "O5"]),
        ])
    }
    
    func test_addingMultipleAnswerQuestion_duplicateQuestions_throws() throws {
        let sut = try TextualQuizBuilder(
            multipleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answers: NonEmptyOptions(head: "O1", tail: ["O3"])
        )
        
        assert(
            try sut.adding(
                multipleAnswerQuestion: "Q1",
                options: NonEmptyOptions(head: "O4", tail: ["O5", "O6"]),
                answers: NonEmptyOptions(head: "O4", tail: ["O5"])
            ),
            throws: .duplicateQuestion(.multipleAnswer("Q1"))
        )
    }
    
    func test_addingMultipleAnswerQuestion_duplicateOptions_throws() throws {
        let sut = try TextualQuizBuilder(
            multipleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answers: NonEmptyOptions(head: "O1", tail: ["O3"])
        )
        
        assert(
            try sut.adding(
                multipleAnswerQuestion: "Q2",
                options: NonEmptyOptions(head: "O4", tail: ["O4", "O5"]),
                answers: NonEmptyOptions(head: "O4", tail: ["O5"])
            ),
            throws: .duplicateOptions(["O4", "O4", "O5"])
        )
    }
    
    func test_addingMultipleAnswerQuestion_duplicateAnswers_throws() throws {
        let sut = try TextualQuizBuilder(
            multipleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answers: NonEmptyOptions(head: "O1", tail: ["O3"])
        )
        
        assert(
            try sut.adding(
                multipleAnswerQuestion: "Q2",
                options: NonEmptyOptions(head: "O4", tail: ["O5", "O6"]),
                answers: NonEmptyOptions(head: "O4", tail: ["O4"])
            ),
            throws: .duplicateAnswers(["O4", "O4"])
        )
    }
    
    func test_addingMultipleAnswerQuestion_missingAnswersInOptions_throws() throws {
        let sut = try TextualQuizBuilder(
            multipleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"]),
            answers: NonEmptyOptions(head: "O1", tail: ["O3"])
        )
        
        assert(
            try sut.adding(
                multipleAnswerQuestion: "Q2",
                options: NonEmptyOptions(head: "O4", tail: ["O5", "O6"]),
                answers: NonEmptyOptions(head: "O4", tail: ["O8"])
            ),
            throws: .missingAnswerInOptions(
                answer: ["O4", "O8"],
                options: ["O4", "O5", "O6"]
            )
        )
    }
    
    // MARK:- Helpers
    
    private func assertEqual(
        _ a1: [(Question<String>, [String])],
        _ a2: [(Question<String>, [String])],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertTrue(
            a1.elementsEqual(a2, by: ==),
            "\(a1) does not equal \(a2)",
            file: file,
            line: line
        )
    }
    
    func assert<T>(
        _ expression: @autoclosure () throws -> T,
        throws expectedError: TextualQuizBuilder.AddingError,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertThrowsError(try expression()) { error in
            XCTAssertEqual(
                error as? TextualQuizBuilder.AddingError,
                expectedError,
                file: file,
                line: line
            )
        }
    }
    
}
