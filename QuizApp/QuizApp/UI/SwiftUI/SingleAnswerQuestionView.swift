//
//  SingleAnswerQuestionView.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 21.09.21.
//

import SwiftUI

struct SingleAnswerQuestionView: View {
    
    let title: String
    let question: String
    let options: [String]
    let selection: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
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
            
            ForEach(options, id: \.self) { option in
                Button(
                    action: {},
                    label: {
                        HStack {
                            Circle()
                                .stroke(Color.secondary, lineWidth: 2.5)
                                .frame(width: 40.0, height: 40.0)
                            
                            Text(option)
                                .font(.title)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                        .padding()
                    }
                )
            }
            
            Spacer()
        }
    }
    
}

struct SingleAnswerQuestionView_Previews: PreviewProvider {
    
    static var previews: some View {
        SingleAnswerQuestionView(
            title: "1 of 2",
            question: "What is 2x2?",
            options: ["2", "4", "6", "22"],
            selection: { _ in }
        )
    }
    
}
