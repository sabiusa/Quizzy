//
//  QuestionHeaderView.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 21.09.21.
//

import SwiftUI

struct QuestionHeaderView: View {
    
    let title: String
    let question: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(Color.blue)
                .padding(.top)
            
            Text(question)
                .font(.largeTitle)
                .fontWeight(.medium)
        }
        .padding()
    }
    
}

struct QuestionHeaderView_Previews: PreviewProvider {
    
    static var previews: some View {
        QuestionHeaderView(title: "Title", question: "Question")
            .previewLayout(.sizeThatFits)
    }
    
}
