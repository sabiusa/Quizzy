//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 16.09.21.
//

import UIKit
import QuizCore

class NavigationControllerRouter: Router {
    
    private let navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func route(
        to question: String,
        answerCallback: @escaping (String) -> Void
    ) {
        navigationController.pushViewController(
            UIViewController(),
            animated: false
        )
    }
    
    func route(to result: QuizResult<String, String>) {
        
    }
    
}
