//
//  MultipleTextSelectionView.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 22.09.21.
//

import SwiftUI

struct MultipleTextSelectionView: View {
    
    @Binding var option: MultipleSelectionOption
    
    var body: some View {
        Button(action: { option.select() }) {
            HStack {
                Rectangle()
                    .strokeBorder(option.isSelected ? Color.blue : Color.secondary, lineWidth: 2.5)
                    .frame(width: 40.0, height: 40.0)
                    .overlay(
                        Rectangle()
                            .fill(option.isSelected ? Color.blue : .clear)
                            .padding(6)
                    )
                
                Text(option.text)
                    .font(.title)
                    .foregroundColor(option.isSelected ? Color.blue : Color.secondary)
                
                Spacer()
            }
            .padding()
        }
    }
    
}

struct MultipleTextSelectionView_Previews: PreviewProvider {
    
    static var previews: some View {
        MultipleTextSelectionView(
            option: .constant(MultipleSelectionOption(text: "Option", isSelected: false))
        )
        .previewLayout(.sizeThatFits)
        
        MultipleTextSelectionView(
            option: .constant(MultipleSelectionOption(text: "Option", isSelected: true))
        )
        .previewLayout(.sizeThatFits)
    }
    
}
