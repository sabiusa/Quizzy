//
//  iOSSwiftUINavigationAdapter.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 22.09.21.
//

import SwiftUI
import QuizCore

final class iOSSwiftUINavigationAdapter: ViewControllerFactory, QuizDelegate {
    
    typealias Question = QuizCore.Question<String>
    typealias Answer = [String]
    typealias Answers = [(question: Question, answer: Answer)]
    
    private let navigation: UINavigationController
    private let options: [Question: Answer]
    private let correctAnswers: Answers
    private let playAgain: () -> Void
    
    private var questions: [Question] {
        return correctAnswers.map(\.question)
    }
    
    init(
        navigation: UINavigationController,
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
        let controller = questionViewController(
            for: question,
            answerCallback: completion
        )
        navigation.pushViewController(controller, animated: true)
    }
    
    func didCompleteQuiz(with answers: Answers) {
        
    }
    
    func questionViewController(
        for question: Question,
        answerCallback: @escaping (Answer) -> Void
    ) -> UIViewController {
        guard let options = options[question] else {
            fatalError("Couldn't find options for question: \(question)")
        }
        
        return questionViewController(
            for: question,
            options: options,
            answerCallback: answerCallback
        )
    }
    
    private func questionViewController(
        for question: Question,
        options: Answer,
        answerCallback: @escaping (Answer) -> Void
    ) -> UIViewController {
        let presenter = QuestionPresenter(
            allQuestions: questions,
            currentQuestion: question
        )
        switch question {
        case .singleAnswer(let text):
            return UIHostingController(
                rootView: SingleAnswerQuestionView(
                    title: presenter.title,
                    question: text,
                    options: options,
                    selection: { selectedAnswer in
                        answerCallback([selectedAnswer])
                    }
                )
            )
            
        case .multipleAnswer(let text):
            return UIHostingController(
                rootView: MultipleAnswerQuestionView(
                    title: presenter.title,
                    question: text,
                    store: MultipleSelectionStore(
                        options: options,
                        handler: answerCallback
                    )
                )
            )
        }
    }
    
    func questionViewController(
        question: Question,
        questionText: String,
        options: Answer,
        allowsMultipleSelection: Bool,
        answerCallback: @escaping (Answer) -> Void
    ) -> UIViewController {
        let presenter = QuestionPresenter(
            allQuestions: questions,
            currentQuestion: question
        )
        let controller = QuestionViewController(
            question: questionText,
            options: options,
            allowsMultipleSelection: allowsMultipleSelection,
            selection: answerCallback
        )
        controller.title = presenter.title
        return controller
    }
    
    func resultViewController(for userAnswers: Answers) -> UIViewController {
        let presenter = ResultsPresenter(
            userAnswers: userAnswers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score
        )
        let resultsHost = UIHostingController(
            rootView: ResultsView(
                title: presenter.title,
                summary: presenter.summary,
                answers: presenter.presentableAnswers,
                playAgain: playAgain
            )
        )
        return resultsHost
    }
    
}


