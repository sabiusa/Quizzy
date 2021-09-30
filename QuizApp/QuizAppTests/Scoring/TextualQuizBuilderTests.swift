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
    
    private var questions: [Question<String>] = []
    private var options: [Question<String>: [String]] = [:]
    private var correctAnswers: [(Question<String>, [String])] = []
    
    enum AddingError: Error, Equatable {
        case duplicateOptions([String])
        case missingAnswerInOptions(answer: [String], options: [String])
        case duplicateQuestion(Question<String>)
        case duplicateAnswers([String])
    }
    
    private init(
        questions: [Question<String>],
        options: [Question<String> : [String]],
        correctAnswers: [(Question<String>, [String])]
    ) {
        self.questions = questions
        self.options = options
        self.correctAnswers = correctAnswers
    }
    
    init(
        singleAnswerQuestion: String,
        options: NonEmptyOptions,
        answer: String
    ) throws {
        try add(
            singleAnswerQuestion: singleAnswerQuestion,
            options: options,
            answer: answer
        )
    }
    
    init(
        multipleAnswerQuestion: String,
        options: NonEmptyOptions,
        answers: NonEmptyOptions
    ) throws {
        let question = Question.multipleAnswer(multipleAnswerQuestion)
        let allOptions = options.all
        let allAnswers = answers.all
        
        guard Set(allAnswers).isSubset(of: Set(allOptions))
        else { throw AddingError.missingAnswerInOptions(answer: allAnswers, options: allOptions) }
        
        guard Set(allAnswers).count == allAnswers.count
        else { throw AddingError.duplicateAnswers(allAnswers) }
        
        guard Set(allOptions).count == allOptions.count
        else { throw AddingError.duplicateOptions(allOptions) }
        
        self.questions = [question]
        self.options = [question: allOptions]
        self.correctAnswers = [(question, allAnswers)]
    }
    
    mutating func add(
        singleAnswerQuestion: String,
        options: NonEmptyOptions,
        answer: String
    ) throws {
        self = try adding(
            singleAnswerQuestion: singleAnswerQuestion,
            options: options,
            answer: answer
        )
    }
    
    func adding(
        singleAnswerQuestion: String,
        options: NonEmptyOptions,
        answer: String
    ) throws -> TextualQuizBuilder {
        let allOptions = options.all
        let question = Question.singleAnswer(singleAnswerQuestion)
        
        guard !questions.contains(question)
        else { throw AddingError.duplicateQuestion(question) }
        
        guard allOptions.contains(answer)
        else { throw AddingError.missingAnswerInOptions(answer: [answer], options: allOptions) }
        
        guard Set(allOptions).count == allOptions.count
        else { throw AddingError.duplicateOptions(allOptions) }
        
        var newOptions = self.options
        newOptions[question] = allOptions
        
        return TextualQuizBuilder(
            questions: questions + [question],
            options: newOptions,
            correctAnswers: correctAnswers + [(question, [answer])]
        )
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
