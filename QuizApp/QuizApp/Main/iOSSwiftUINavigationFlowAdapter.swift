//
//  iOSSwiftUINavigationFlowAdapter.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 28.09.21.
//

import SwiftUI
import QuizCore

class iOSSwiftUINavigationFlowAdapter: QuizDelegate {
    
    typealias Question = QuizCore.Question<String>
    typealias Answer = [String]
    typealias Answers = [(question: Question, answer: Answer)]
    
    private let navigator: UINavigationController
    private let questions: [Question]
    private let options: [Question: Answer]
    private let correctAnswers: Answers
    private let playAgain: () -> Void
    
    init(
        navigator: UINavigationController,
        questions: [Question],
        options: [Question: Answer],
        correctAnswers: Answers,
        playAgain: @escaping () -> Void
    ) {
        self.navigator = navigator
        self.questions = questions
        self.options = options
        self.correctAnswers = correctAnswers
        self.playAgain = playAgain
    }
    
    func answer(
        for question: Question,
        completion: @escaping (Answer) -> Void
    ) {
        guard let options = options[question] else {
            fatalError("Options not found for question: \(question)")
        }
        
        let presenter = QuestionPresenter(
            allQuestions: questions,
            currentQuestion: question
        )
        
        switch question {
        case .singleAnswer(let text):
            let singleView = SingleAnswerQuestionView(
                title: presenter.title,
                question: text,
                options: options,
                selection: { selection in
                    completion([selection])
                }
            )
            let host = UIHostingController(rootView: singleView)
            navigator.setViewControllers([host], animated: true)
        case .multipleAnswer(let text):
            let multipleView = MultipleAnswerQuestionView(
                title: presenter.title,
                question: text,
                store: MultipleSelectionStore(
                    options: options,
                    handler: { _ in }
                )
            )
            let host = UIHostingController(rootView: multipleView)
            navigator.setViewControllers([host], animated: true)
        }
    }
    
    func didCompleteQuiz(with answers: Answers) {
        let presenter = ResultsPresenter(
            userAnswers: answers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score
        )
        
        let resultsView = ResultsView(
            title: presenter.title,
            summary: presenter.summary,
            answers: presenter.presentableAnswers,
            playAgain: playAgain
        )
        let host = UIHostingController(rootView: resultsView)
        navigator.setViewControllers([host], animated: true)
    }
    
}
