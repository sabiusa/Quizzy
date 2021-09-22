//
//  MultipleSelectionStoreTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 22.09.21.
//

import XCTest

struct MultipleSelectionStore {
    
    var options: [MultipleSelectionOption]
    
    var canSubmit: Bool { options.contains(where: \.isSelected) }
    
    init(options: [String]) {
        self.options = options.map(MultipleSelectionOption.init)
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
    
}
