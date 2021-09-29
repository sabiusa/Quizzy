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
}

struct TextualQuizBuilder {
    
    private let questions: [Question<String>]
    private let options: [Question<String>: [String]]
    
    init(
        singleAnswerQuestion: String,
        options: NonEmptyOptions
    ) {
        let question = Question.singleAnswer(singleAnswerQuestion)
        self.questions = [question]
        self.options = [question: [options.head] + options.tail]
    }
    
    func build() -> TextualQuiz {
        return TextualQuiz(
            questions: questions,
            options: options
        )
    }
    
}

class TextualQuizBuilderTests: XCTestCase {
    
    func test_initWithSingleAnswerQuestion() {
        let sut = TextualQuizBuilder(
            singleAnswerQuestion: "Q1",
            options: NonEmptyOptions(head: "O1", tail: ["O2", "O3"])
        )
        
        let quiz = sut.build()
        
        XCTAssertEqual(quiz.questions, [.singleAnswer("Q1")])
        XCTAssertEqual(quiz.options, [.singleAnswer("Q1"): ["O1", "O2", "O3"]])
    }
    
}
