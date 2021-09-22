//
//  MultipleSelectionStoreTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 22.09.21.
//

import XCTest

@testable import QuizApp

class MultipleSelectionStoreTests: XCTestCase {
    
    func test_selectOption_togglesState() {
        var sut = makeSUT(options: ["o1", "o2", "o3"])
        XCTAssertFalse(sut.options[0].isSelected)
        
        sut.options[0].toggleSelection()
        XCTAssertTrue(sut.options[0].isSelected)
        
        sut.options[0].toggleSelection()
        XCTAssertFalse(sut.options[0].isSelected)
    }
    
    func test_canSubmit_whenAtLeastOneOptionIsSelected() {
        var sut = makeSUT(options: ["o1", "o2", "o3"])
        XCTAssertFalse(sut.canSubmit)
        
        sut.options[0].toggleSelection()
        XCTAssertTrue(sut.canSubmit)
        
        sut.options[0].toggleSelection()
        XCTAssertFalse(sut.canSubmit)
        
        sut.options[1].toggleSelection()
        XCTAssertTrue(sut.canSubmit)
    }
    
    func test_submit_notifiesHandlerWithSelectedOptions() {
        var submittedOptions = [[String]]()
        var sut = makeSUT(options: ["o1", "o2", "o3"], handler: {
            submittedOptions.append($0)
        })
        
        sut.submit()
        XCTAssertEqual(submittedOptions, [])
        
        sut.options[0].toggleSelection()
        sut.submit()
        XCTAssertEqual(submittedOptions, [["o1"]])
        
        sut.options[1].toggleSelection()
        sut.submit()
        XCTAssertEqual(submittedOptions, [["o1"], ["o1", "o2"]])
        
        sut.options[0].toggleSelection()
        sut.submit()
        XCTAssertEqual(submittedOptions, [["o1"], ["o1", "o2"], ["o2"]])
    }
    
    // MARK: - Helpers
        
    private func makeSUT(
        options: [String],
        handler: @escaping ([String]) -> Void = { _ in }
    ) -> MultipleSelectionStore {
        let sut = MultipleSelectionStore(options: options, handler: handler)
        return sut
    }
    
}
