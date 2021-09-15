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
        let sut = Flow(router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestionCount, 0)
    }
    
    private class RouterSpy: Router {
        var routedQuestionCount = 0
    }
    
}
