//
//  ViewControllerFactory.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 17.09.21.
//

import UIKit
import TextualQuizDomain

protocol ViewControllerFactory {
    
    typealias Answers = [(question: Question<String>, answer: [String])]
    
    func questionViewController(
        for question: Question<String>,
        answerCallback: @escaping ([String]) -> Void
    ) -> UIViewController
    
    func resultViewController(for userAnswers: Answers) -> UIViewController
    
}
