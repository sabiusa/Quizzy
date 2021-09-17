//
//  ViewControllerFactory.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 17.09.21.
//

import UIKit
import QuizCore

protocol ViewControllerFactory {
    
    func questionViewController(
        for question: Question<String>,
        answerCallback: @escaping (String) -> Void
    ) -> UIViewController
    
    func resultViewController(
        for result: QuizResult<Question<String>, String>
    ) -> UIViewController
    
}
