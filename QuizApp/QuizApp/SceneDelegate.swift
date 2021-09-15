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
            newWindow.rootViewController = QuestionViewController(
                question: "A question?",
                options: ["Option 1", "Option 2", "Option 3"],
                selection: { print($0) }
            )
            
            window = newWindow
            window?.makeKeyAndVisible()
        }
    }

}

