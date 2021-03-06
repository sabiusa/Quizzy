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
            HeaderView(title: title, subtitle: question)
            
            ForEach(options, id: \.self) { option in
                SingleTextSelectionView(
                    text: option,
                    selection: {
                        selection(option)
                    }
                )
            }
            
            Spacer()
        }
    }
    
}

struct SingleAnswerQuestionView_Previews: PreviewProvider {
    
    static var previews: some View {
        SingleAnswerQuestionTestView()
    }
    
    struct SingleAnswerQuestionTestView: View {
        
        @State var selection: String = "none"
        
        var body: some View {
            VStack {
                SingleAnswerQuestionView(
                    title: "1 of 2",
                    question: "What is 2x2?",
                    options: ["2", "4", "6", "22"],
                    selection: { selection = $0 }
                )
                
                Text("Last selection: " + selection)
            }
        }
        
    }
    
}
