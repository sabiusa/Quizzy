//
//  TextualQuizBuilderTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 28.09.21.
//

import XCTest
import QuizCore

struct TextualQuiz {
    
    let questions: [Question<String>]
    let options: [Question<String>: [String]]
    let correctAnswers: [(Question<String>, [String])]
}

struct NonEmptyOptions {
    let head: String
    let tail: [String]
    
    var all: [String] {
        return [head] + tail
    }
}

struct TextualQuizBuilder {
    
    private var questions: [Question<String>]
    private var options: [Question<String>: [String]]
    private var correctAnswers: [(Question<String>, [String])]
    
    enum AddingError: Error, Equatable {
        case duplicateOptions([String])
        case missingAnswerInOptions(answer: [String], options: [String])
        case duplicateQuestion(Question<String>)
    }
    
    init(
        singleAnswerQuestion: String,
        options: NonEmptyOptions,
        answer: String
    ) throws {
        let allOptions = options.all
        
        guard allOptions.contains(answer)
        else { throw AddingError.missingAnswerInOptions(answer: [answer], options: allOptions) }
        
        guard Set(allOptions).count == allOptions.count
        else { throw AddingError.duplicateOptions(allOptions) }
        
        let question = Question.singleAnswer(singleAnswerQuestion)
        self.questions = [question]
        self.options = [question: allOptions]
        self.correctAnswers = [(question, [answer])]
    }
    
    mutating func add(
        singleAnswerQuestion: String,
        options: NonEmptyOptions,
        answer: String
    ) throws {
        let allOptions = options.all
        let question = Question.singleAnswer(singleAnswerQuestion)
        
        guard !questions.contains(question)
        else { throw AddingError.duplicateQuestion(question) }
        
        guard allOptions.contains(answer)
        else { throw AddingError.missingAnswerInOptions(answer: [answer], options: allOptions) }
        
        guard Set(allOptions).count == allOptions.count
        else { throw AddingError.duplicateOptions(allOptions) }
        
        self.questions.append(question)
        self.options[question] = allOptions
        self.correctAnswers.append((question, [answer]))
    }
    
    func build() -> TextualQuiz {
        return TextualQuiz(
            questions: questions,
            options: options,
            correctAnswers: correctAnswers
        )
    }
    
}

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
