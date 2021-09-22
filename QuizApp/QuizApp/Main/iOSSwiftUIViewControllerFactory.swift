//
//  iOSSwiftUIViewControllerFactory.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 22.09.21.
//

import SwiftUI
import UIKit
import QuizCore

final class iOSSwiftUIViewControllerFactory: ViewControllerFactory {
    
    typealias Answers = [(question: Question<String>, answer: [String])]
    
    private let options: [Question<String>: [String]]
    private let correctAnswers: Answers
    
    private var questions: [Question<String>] {
        return correctAnswers.map(\.question)
    }
    
    init(
        options: [Question<String>: [String]],
        correctAnswers: Answers
    ) {
        self.options = options
        self.correctAnswers = correctAnswers
    }
    
    func questionViewController(
        for question: Question<String>,
        answerCallback: @escaping ([String]) -> Void
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
        for question: Question<String>,
        options: [String],
        answerCallback: @escaping ([String]) -> Void
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
        question: Question<String>,
        questionText: String,
        options: [String],
        allowsMultipleSelection: Bool,
        answerCallback: @escaping ([String]) -> Void
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
                playAgain: {}
            )
        )
        return resultsHost
    }
    
}

