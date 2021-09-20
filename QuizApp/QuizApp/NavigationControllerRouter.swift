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
        answerCallback: @escaping ([String]) -> Void
    ) {
        switch question {
        case .singleAnswer:
            show(
                factory.questionViewController(
                    for: question,
                    answerCallback: answerCallback
                )
            )
        case .multipleAnswer:
            let barButton = UIBarButtonItem(
                title: "Submit",
                style: .done,
                target: nil,
                action: nil
            )
            barButton.isEnabled = false
            let controller = factory.questionViewController(
                for: question,
                answerCallback: { selection in
                    barButton.isEnabled = !selection.isEmpty
                }
            )
            controller.navigationItem.rightBarButtonItem = barButton
            show(controller)
        }
    }
    
    func route(to result: QuizResult<Question<String>, [String]>) {
        show(factory.resultViewController(for: result))
    }
    
    private func show(_ viewController: UIViewController) {
        navigationController.pushViewController(
            viewController,
            animated: true
        )
    }
    
}
