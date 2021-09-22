//
//  MultipleAnswerQuestionSnapshotTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 22.09.21.
//

import XCTest

@testable import QuizApp

class MultipleAnswerQuestionSnapshotTests: XCTestCase {
    
    func test() {
        let sut = MultipleAnswerQuestionView(
            title: "Title",
            question: "Question",
            store: MultipleSelectionStore(
                options: ["Option 1", "Option 2", "Option 3"]
            )
        )
        
        XCTAssertNotNil(sut) // to silent warning of unusable `sut`
//        record(snapshot: sut.snapshot(), named: "three_options")
//        assert(snapshot: sut.snapshot(), named: "three_options")
    }
    
}
