//
//  FlowTests.swift
//  QuizCoreTests
//
//  Created by Saba Khutsishvili on 15.09.21.
//

import Foundation
import XCTest

@testable import QuizCore

class FlowTests: XCTestCase {
    
    func test_start_withNoQuestions_doesNoRouteToQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: [], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestionCount, 0)
    }
    
    func test_start_withOneQuestions_routesToCorrectQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1"], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withTwoQuestions_routesToFirstQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1", "Q2"], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_routesToFirstQuestionTwice() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1", "Q2"], router: router)

        sut.start()
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    private class RouterSpy: Router {
        var routedQuestions = [String]()
        
        var routedQuestionCount: Int {
            return routedQuestions.count
        }
        
        func route(to question: String) {
            routedQuestions.append(question)
        }
    }
    
}
