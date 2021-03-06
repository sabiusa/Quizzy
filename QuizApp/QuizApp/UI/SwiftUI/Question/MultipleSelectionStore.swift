//
//  MultipleSelectionStore.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 22.09.21.
//

import Foundation

struct MultipleSelectionStore {
    
    private let handler: ([String]) -> Void
    
    var options: [MultipleSelectionOption]
    
    var canSubmit: Bool { options.contains(where: \.isSelected) }
    
    init(
        options: [String],
        handler: @escaping ([String]) -> Void
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
    
    init(text: String, isSelected: Bool = false) {
        self.text = text
        self.isSelected = isSelected
    }
    
    mutating func toggleSelection() {
        isSelected.toggle()
    }
    
}
