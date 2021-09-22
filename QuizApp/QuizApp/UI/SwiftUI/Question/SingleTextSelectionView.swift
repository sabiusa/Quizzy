//
//  SingleTextSelectionView.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 21.09.21.
//

import SwiftUI

struct SingleTextSelectionView: View {
    
    let text: String
    let selection: () -> Void
    
    var body: some View {
        Button(action: selection) {
            HStack {
                Circle()
                    .stroke(Color.secondary, lineWidth: 2.5)
                    .frame(width: 40.0, height: 40.0)
                
                Text(text)
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
        }
    }
    
}

struct SingleTextSelectionView_Previews: PreviewProvider {
    
    static var previews: some View {
        SingleTextSelectionView(text: "Option", selection: {})
            .previewLayout(.sizeThatFits)
    }
    
}
