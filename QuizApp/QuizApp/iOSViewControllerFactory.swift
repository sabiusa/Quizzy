//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 17.09.21.
//

import UIKit
import QuizCore

class iOSViewControllerFactory: ViewControllerFactory {
    
    private let options: [Question<String>: [String]]
    
    init(options: [Question<String>: [String]]) {
        self.options = options
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
            let controller = QuestionViewController(
                question: text,
                options: options,
                selection: answerCallback
            )
            controller.title = "Question #1"
            return controller
            
        case .multipleAnswer(let text):
            let controller = QuestionViewController(
                question: text,
                options: options,
                selection: answerCallback
            )
            controller.loadViewIfNeeded()
            controller.tableView.allowsMultipleSelection = true
            return controller
        }
    }
    
    func resultViewController(
        for result: QuizResult<Question<String>, [String]>
    ) -> UIViewController {
        return UIViewController()
    }
    
}
