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
    
}

struct TextualQuizBuilder {
    
    private let questions: [Question<String>]
    
    init(singleAnswerQuestion: String) {
        questions = [.singleAnswer(singleAnswerQuestion)]
    }
    
    func build() -> TextualQuiz {
        return TextualQuiz(questions: questions)
    }
    
}

class TextualQuizBuilderTests: XCTestCase {
    
    func test_initWithSingleAnswerQuestion() {
        let sut = TextualQuizBuilder(singleAnswerQuestion: "Q1")
        
        let quiz = sut.build()
        
        XCTAssertEqual(quiz.questions, [.singleAnswer("Q1")])
    }
    
}
