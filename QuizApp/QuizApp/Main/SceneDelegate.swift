//
//  SceneDelegate.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 15.09.21.
//

import UIKit
import QuizCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var quiz: Quiz?
    
    private lazy var navigationController = UINavigationController()
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let newWindow = UIWindow(windowScene: windowScene)
        newWindow.rootViewController = navigationController
        window = newWindow
        window?.makeKeyAndVisible()
        
        startNewSwiftUIRouterQuiz()
    }
    
    private func startNewUIKitQuiz() {
        let question1 = Question.singleAnswer("What is 2x2?")
        let question2 = Question.multipleAnswer("How to get 8")
        let questions = [question1, question2]
        
        let option1 = "2", option2 = "4", option3 = "6"
        let options1 = [option1, option2, option3]
        
        let option4 = "3 + 5", option5 = "2 + 7", option6 = "5 + 5", option7 = "0 + 8"
        let options2 = [option4, option5, option6, option7]
        let allOptions = [question1: options1, question2: options2]
        
        let correctAnswers = [
            (question1, [option2]),
            (question2, [option4, option7])
        ]
        
        let factory = iOSUIKitViewControllerFactory(
            options: allOptions,
            correctAnswers: correctAnswers
        )
        
        let router = NavigationControllerRouter(navigationController, factory: factory)
        
        quiz = Quiz.start(
            questions: questions,
            delegate: router
        )
    }
    
    private func startNewSwiftUIRouterQuiz() {
        let question1 = Question.singleAnswer("What is 2x2?")
        let question2 = Question.multipleAnswer("How to get 8")
        let questions = [question1, question2]
        
        let option1 = "2", option2 = "4", option3 = "6"
        let options1 = [option1, option2, option3]
        
        let option4 = "3 + 5", option5 = "2 + 7", option6 = "5 + 5", option7 = "0 + 8"
        let options2 = [option4, option5, option6, option7]
        let allOptions = [question1: options1, question2: options2]
        
        let correctAnswers = [
            (question1, [option2]),
            (question2, [option4, option7])
        ]
        
        let factory = iOSSwiftUIViewControllerFactory(
            options: allOptions,
            correctAnswers: correctAnswers,
            playAgain: startNewSwiftUIRouterQuiz
        )
        
        let router = NavigationControllerRouter(navigationController, factory: factory)
        
        quiz = Quiz.start(
            questions: questions,
            delegate: router
        )
    }

}

