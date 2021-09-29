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
    
}

struct NonEmptyOptions {
    let head: String
    let tail: [String]
    
    var all: [String] {
        return [head] + tail
    }
}

struct TextualQuizBuilder {
    
    private let questions: [Question<String>]
    private let options: [Question<String>: [String]]
    
    enum AddingError: Error, Equatable {
        case duplicateOptions([String])
    }
    
    init(
        singleAnswerQuestion: String,
        options: NonEmptyOptions
    ) throws {
        let allOptions = options.all
        
        guard Set(allOptions).count == allOptions.count
        else { throw AddingError.duplicateOptions(allOptions) }
        
        let question = Question.singleAnswer(singleAnswerQuestion)
        self.questions = [question]
        self.options = [question: allOptions]
    }
    
    func build() -> TextualQuiz {
        return TextualQuiz(
            questions: questions,
            options: options
        )
    }
    
}

class TextualQuizBuilderTests: XCTestCase {
    
    func test_initWithSingleAnswerQuestion() throws {
        let sut = try TextualQuizBuilder(
            singleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"])
        )
        
        let quiz = sut.build()
        
        XCTAssertEqual(quiz.questions, [.singleAnswer("Q1")])
        XCTAssertEqual(quiz.options, [.singleAnswer("Q1"): ["O1", "O2", "O3"]])
    }
    
    func test_initWithSingleAnswerQuestion_duplicateOptions_throws() throws {
        XCTAssertThrowsError(
            try TextualQuizBuilder(
                singleAnswerQuestion: "Q1",
                options: NonEmptyOptions(head: "O1", tail: ["O1", "O3"])
            )
        ) { error in
            XCTAssertEqual(
                error as? TextualQuizBuilder.AddingError,
                TextualQuizBuilder.AddingError.duplicateOptions(["O1", "O1", "O3"])
            )
        }
    }
    
}
