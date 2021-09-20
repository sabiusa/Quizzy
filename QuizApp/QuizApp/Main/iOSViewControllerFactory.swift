//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 17.09.21.
//

import UIKit
import QuizCore

class iOSViewControllerFactory: ViewControllerFactory {
    
    private let questions: [Question<String>]
    private let options: [Question<String>: [String]]
    private let correctAnswers: [Question<String>: [String]]
    
    init(
        questions: [Question<String>],
        options: [Question<String>: [String]],
        correctAnswers: [Question<String>: [String]]
    ) {
        self.questions = questions
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
        switch question {
        case .singleAnswer(let text):
            return questionViewController(
                question: question,
                questionText: text,
                options: options,
                allowsMultipleSelection: false,
                answerCallback: answerCallback
            )
            
        case .multipleAnswer(let text):
            return questionViewController(
                question: question,
                questionText: text,
                options: options,
                allowsMultipleSelection: true,
                answerCallback: answerCallback
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
    
    func resultViewController(
        for result: QuizResult<Question<String>, [String]>
    ) -> UIViewController {
        let presenter = ResultsPresenter(
            questions: questions,
            result: result,
            correctAnswers: correctAnswers
        )
        let controller = ResultsViewController(
            summary: presenter.summary,
            answers: presenter.presentableAnswers
        )
        controller.title = presenter.title
        return controller
    }
    
}