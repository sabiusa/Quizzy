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
        switch question {
        case .singleAnswer(let text):
            return QuestionViewController(
                question: text,
                options: options[question]!,
                selection: answerCallback
            )
        default:
            return UIViewController()
        }
    }
    
    func resultViewController(
        for result: QuizResult<Question<String>, [String]>
    ) -> UIViewController {
        return UIViewController()
    }
    
}
