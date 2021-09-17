//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 17.09.21.
//

import UIKit
import QuizCore

class iOSViewControllerFactory: ViewControllerFactory {
    
    func questionViewController(
        for question: Question<String>,
        answerCallback: @escaping (String) -> Void
    ) -> UIViewController {
        return QuestionViewController()
    }
    
    func resultViewController(
        for result: QuizResult<Question<String>, String>
    ) -> UIViewController {
        return UIViewController()
    }
    
}
