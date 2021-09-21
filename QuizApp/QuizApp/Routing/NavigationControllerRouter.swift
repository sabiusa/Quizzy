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
    
    func answer(
        for question: Question<String>,
        completion: @escaping ([String]) -> Void
    ) {
        switch question {
        case .singleAnswer:
            show(
                factory.questionViewController(
                    for: question,
                    answerCallback: completion
                )
            )
        case .multipleAnswer:
            let barButton = UIBarButtonItem(
                title: "Submit",
                style: .done,
                target: nil,
                action: nil
            )
            let buttonController = SubmitButtonController(
                button: barButton,
                callback: completion
            )
            let controller = factory.questionViewController(
                for: question,
                answerCallback: { selection in
                    buttonController.update(with: selection)
                }
            )
            controller.navigationItem.rightBarButtonItem = barButton
            show(controller)
        }
    }
    
    func route(
        to question: Question<String>,
        answerCallback: @escaping ([String]) -> Void
    ) {
        answer(for: question, completion: answerCallback)
    }
    
    func didCompleteQuiz(
        with answers: [(question: Question<String>, answers: [String])]
    ) {
        show(factory.resultViewController(for: answers))
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

private class SubmitButtonController: NSObject {
    
    let button: UIBarButtonItem
    let callback: ([String]) -> Void
    
    private var model: [String] = []
    
    init(
        button: UIBarButtonItem,
        callback: @escaping ([String]) -> Void
    ) {
        self.button = button
        self.callback = callback
        super.init()
        self.setup()
    }
    
    private func setup() {
        button.target = self
        button.action = #selector(fireCallback)
        updateButtonSate()
    }
    
    func update(with newModel: [String]) {
        model = newModel
        updateButtonSate()
    }
    
    private func updateButtonSate() {
        button.isEnabled = model.count > 0
    }
    
    @objc
    private func fireCallback() {
        callback(model)
    }
    
}
