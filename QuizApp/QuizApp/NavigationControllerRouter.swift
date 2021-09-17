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
        for question: String,
        answerCallback: (String) -> Void
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
        to question: String,
        answerCallback: @escaping (String) -> Void
    ) {
        let viewController = factory.questionViewController(
            for: question,
            answerCallback: answerCallback
        )
        navigationController.pushViewController(
            viewController,
            animated: false
        )
    }
    
    func route(to result: QuizResult<String, String>) {
        
    }
    
}
