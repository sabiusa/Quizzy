//
//  SceneDelegate.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 15.09.21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let windowScene = scene as? UIWindowScene {
            let newWindow = UIWindow(windowScene: windowScene)
            newWindow.rootViewController = createResultsViewController()
            
            window = newWindow
            window?.makeKeyAndVisible()
        }
    }
    
    private func createQuestionViewController() -> QuestionViewController {
        return QuestionViewController(
            question: "A question?",
            options: ["Option 1", "Option 2", "Option 3"],
            selection: { print($0) }
        )
    }
    
    private func createResultsViewController() -> ResultsViewController {
        return ResultsViewController(
            summary: "You got 1/2 correct",
            answers: [
                PresentableAnswer(
                    question: "Question 1",
                    correctAnswer: "Yes",
                    wrongAnswer: nil
                ),
                PresentableAnswer(
                    question: "Another Question",
                    correctAnswer: "No",
                    wrongAnswer: "Sad"
                )
            ]
        )
    }

}

