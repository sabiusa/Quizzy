//
//  QuizNavigationView.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 24.09.21.
//

import SwiftUI

class QuizNavigationStore: ObservableObject {
    
    enum CurrentView {
        case single(SingleAnswerQuestionView)
        case multiple(MultipleAnswerQuestionView)
        case result(ResultsView)
    }
    
    @Published var currentView: CurrentView?
    
    var view: AnyView {
        switch currentView {
        case let .single(view): return AnyView(view)
        case let .multiple(view): return AnyView(view)
        case let .result(view): return AnyView(view)
        case .none: return AnyView(EmptyView())
        }
    }
    
}

struct QuizNavigationView: View {
    
    @ObservedObject var store: QuizNavigationStore
    
    var body: some View {
        store.view
    }
    
}

struct QuizNavigationView_Previews: PreviewProvider {
    
    static var previews: some View {
        QuizNavigationView(store: QuizNavigationStore())
    }
    
}
