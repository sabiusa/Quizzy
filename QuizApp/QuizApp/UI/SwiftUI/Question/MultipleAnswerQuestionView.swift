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
            HeaderView(title: title, subtitle: question)
            
            ForEach(store.options.indices) { i in
                MultipleTextSelectionView(option: $store.options[i])
            }
            
            Spacer()
            
            RoundedButton(
                title: "Submit",
                isEnabled: store.canSubmit,
                action: store.submit
            )
            .padding()
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

