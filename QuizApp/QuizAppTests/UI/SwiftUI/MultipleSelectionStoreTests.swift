//
//  MultipleSelectionStoreTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 22.09.21.
//

import XCTest

struct MultipleSelectionStore {
    
    private let handler: ([String]) -> Void
    
    var options: [MultipleSelectionOption]
    
    var canSubmit: Bool { options.contains(where: \.isSelected) }
    
    init(
        options: [String],
        handler: @escaping ([String]) -> Void = { _ in }
    ) {
        self.options = options.map(MultipleSelectionOption.init)
        self.handler = handler
    }
    
    func submit() {
        guard canSubmit else { return }
        
        handler(options.filter(\.isSelected).map(\.text))
    }
    
}

struct MultipleSelectionOption {
    
    let text: String
    var isSelected = false
    
    init(text: String) {
        self.text = text
    }
    
    mutating func select() {
        isSelected.toggle()
    }
    
}

class MultipleSelectionStoreTests: XCTestCase {
    
    func test_selectOption_togglesState() {
        var sut = MultipleSelectionStore(options: ["o1", "o2", "o3"])
        XCTAssertFalse(sut.options[0].isSelected)
        
        sut.options[0].select()
        XCTAssertTrue(sut.options[0].isSelected)
        
        sut.options[0].select()
        XCTAssertFalse(sut.options[0].isSelected)
    }
    
    func test_canSubmit_whenAtLeastOneOptionIsSelected() {
        var sut = MultipleSelectionStore(options: ["o1", "o2", "o3"])
        XCTAssertFalse(sut.canSubmit)
        
        sut.options[0].select()
        XCTAssertTrue(sut.canSubmit)
        
        sut.options[0].select()
        XCTAssertFalse(sut.canSubmit)
        
        sut.options[1].select()
        XCTAssertTrue(sut.canSubmit)
    }
    
    func test_submit_notifiesHandlerWithSelectedOptions() {
        var submittedOptions = [[String]]()
        var sut = MultipleSelectionStore(options: ["o1", "o2", "o3"], handler: {
            submittedOptions.append($0)
        })
        
        sut.submit()
        XCTAssertEqual(submittedOptions, [])
        
        sut.options[0].select()
        sut.submit()
        XCTAssertEqual(submittedOptions, [["o1"]])
        
        sut.options[1].select()
        sut.submit()
        XCTAssertEqual(submittedOptions, [["o1"], ["o1", "o2"]])
        
        sut.options[0].select()
        sut.submit()
        XCTAssertEqual(submittedOptions, [["o1"], ["o1", "o2"], ["o2"]])
    }
    
}
