//
//  RoundedButton.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 22.09.21.
//

import SwiftUI

struct RoundedButton: View {
    
    let title: String
    let isEnabled: Bool
    let action: () -> Void
    
    init(
        title: String,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action, label: {
            HStack {
                Spacer()
                
                Text(title)
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                
                Spacer()
            }
            .background(Color.blue)
            .cornerRadius(24)
        })
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
    }
    
}

struct RoundedButton_Previews: PreviewProvider {
    
    static var previews: some View {
        RoundedButton(title: "Enabled", isEnabled: true, action: {})
            .previewLayout(.sizeThatFits)
        
        RoundedButton(title: "Disabled", isEnabled: false, action: {})
            .previewLayout(.sizeThatFits)
    }
    
}
