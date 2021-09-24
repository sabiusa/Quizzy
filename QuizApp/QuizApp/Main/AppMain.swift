//
//  AppMain.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 24.09.21.
//

import SwiftUI
import QuizCore

class QuizAppStore {
    var quiz: Quiz?
}

@available(iOS 14, *)
//@main
struct QuizApp: App {
    
    let appStore = QuizAppStore()
    @StateObject var navigationStore = QuizNavigationStore()

    var body: some Scene {
        WindowGroup {
            Color.green
//            QuizNavigationView(store: navigationStore)
//                .onAppear {
//                    startNewQuiz()
//                }
        }
    }

    private func startNewQuiz() {
        let (questions, options, correctAnswers) = Questionnare.getQuizData()
        
        let adapter = iOSSwiftUINavigationAdapter(
            navigation: navigationStore,
            options: options,
            correctAnswers: correctAnswers,
            playAgain: startNewQuiz
        )

        appStore.quiz = Quiz.start(
            questions: questions,
            delegate: adapter
        )
    }
    
}
