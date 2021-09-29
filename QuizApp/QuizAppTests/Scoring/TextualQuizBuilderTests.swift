//
//  TextualQuizBuilderTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 28.09.21.
//

import XCTest

struct TextualQuiz {
    
}

struct TextualQuizBuilder {
    
    func build() -> TextualQuiz? {
        return nil
    }
    
}

class TextualQuizBuilderTests: XCTestCase {
    
    func test_empty() {
        let sut = TextualQuizBuilder()
        
        let quiz = sut.build()
        
        XCTAssertNil(quiz)
    }
    
}
