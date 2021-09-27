//
//  iOSSwiftUINavigationStoreAdapter.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 22.09.21.
//

import SwiftUI
import QuizCore

final class iOSSwiftUINavigationStoreAdapter: QuizDelegate {
    
    typealias Question = QuizCore.Question<String>
    typealias Answer = [String]
    typealias Answers = [(question: Question, answer: Answer)]
    
    private let navigation: QuizNavigationStore
    private let options: [Question: Answer]
    private let correctAnswers: Answers
    private let playAgain: () -> Void
    
    private var questions: [Question] {
        return correctAnswers.map(\.question)
    }
    
    init(
        navigation: QuizNavigationStore,
        options: [Question: Answer],
        correctAnswers: Answers,
        playAgain: @escaping () -> Void
    ) {
        self.navigation = navigation
        self.options = options
        self.correctAnswers = correctAnswers
        self.playAgain = playAgain
    }
    
    func answer(for question: Question, completion: @escaping (Answer) -> Void) {
        guard let options = options[question] else {
            fatalError("Couldn't find options for question: \(question)")
        }
        
        let presenter = QuestionPresenter(
            allQuestions: questions,
            currentQuestion: question
        )
        
        switch question {
        case .singleAnswer(let text):
            navigation.currentView = .single(
                SingleAnswerQuestionView(
                    title: presenter.title,
                    question: text,
                    options: options,
                    selection: { selectedAnswer in
                        completion([selectedAnswer])
                    }
                )
            )
            
        case .multipleAnswer(let text):
            navigation.currentView = .multiple(
                MultipleAnswerQuestionView(
                    title: presenter.title,
                    question: text,
                    store: MultipleSelectionStore(
                        options: options,
                        handler: completion
                    )
                )
            )
        }
    }
    
    func didCompleteQuiz(with answers: Answers) {
        let presenter = ResultsPresenter(
            userAnswers: answers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score
        )
        
        navigation.currentView = .result(
            ResultsView(
                title: presenter.title,
                summary: presenter.summary,
                answers: presenter.presentableAnswers,
                playAgain: playAgain
            )
        )
    }
    
}


