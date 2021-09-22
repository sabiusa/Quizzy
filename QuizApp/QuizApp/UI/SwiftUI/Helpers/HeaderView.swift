//
//  HeaderView.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 21.09.21.
//

import SwiftUI

struct HeaderView: View {
    
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(Color.blue)
                .padding(.top)
            
            Text(subtitle)
                .font(.largeTitle)
                .fontWeight(.medium)
        }
        .padding()
    }
    
}

struct HeaderView_Previews: PreviewProvider {
    
    static var previews: some View {
        HeaderView(title: "Title", subtitle: "Subtitle")
            .previewLayout(.sizeThatFits)
    }
    
}
