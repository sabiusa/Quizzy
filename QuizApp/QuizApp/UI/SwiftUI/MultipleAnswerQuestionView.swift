//
//  MultipleAnswerQuestionView.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 22.09.21.
//

import SwiftUI

struct MultipleAnswerQuestionView: View {
    
    let title: String
    let question: String
    
    @State var store: MultipleSelectionStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            QuestionHeaderView(title: title, question: question)
            
            ForEach(store.options.indices) { i in
                MultipleTextSelectionView(option: $store.options[i])
            }
            
            Spacer()
            
            Button(action: store.submit, label: {
                HStack {
                    Spacer()
                    
                    Text("Submit")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .background(Color.blue)
                .cornerRadius(24)
            })
            .buttonStyle(PlainButtonStyle())
            .padding()
            .disabled(!store.canSubmit)
        }
    }
    
}

struct MultipleAnswerQuestionView_Previews: PreviewProvider {
    
    static var previews: some View {
        MultipleAnswerQuestionTestView()
    }
    
    struct MultipleAnswerQuestionTestView: View {
        
        @State var selection = ["none"]
        
        var body: some View {
            VStack {
                MultipleAnswerQuestionView(
                    title: "1 of 2",
                    question: "What is 2x2?",
                    store: MultipleSelectionStore(
                        options: ["2", "4", "6", "22"],
                        handler: { selection = $0 }
                    )
                )
                
                Text("Last submission: " + selection.joined(separator: ", "))
            }
        }
        
    }
    
}

