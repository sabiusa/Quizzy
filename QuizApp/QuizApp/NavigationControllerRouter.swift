//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 16.09.21.
//

import UIKit
import QuizCore

protocol ViewControllerFactory {
    
    func questionViewController(
        for question: Question<String>,
        answerCallback: @escaping (String) -> Void
    ) -> UIViewController
    
}

class NavigationControllerRouter: Router {
    
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(
        _ navigationController: UINavigationController,
        factory: ViewControllerFactory
    ) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func route(
        to question: Question<String>,
        answerCallback: @escaping (String) -> Void
    ) {
        let viewController = factory.questionViewController(
            for: question,
            answerCallback: answerCallback
        )
        navigationController.pushViewController(
            viewController,
            animated: true
        )
    }
    
    func route(to result: QuizResult<Question<String>, String>) {
        
    }
    
}
