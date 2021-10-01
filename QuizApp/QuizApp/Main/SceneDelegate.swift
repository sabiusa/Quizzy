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
        
        startNewSwiftUIQuiz()
    }
    
    private func startNewUIKitQuiz() {
        let questions = demoQuiz.questions
        let options = demoQuiz.options
        let correctAnswers = demoQuiz.correctAnswers
        
        let factory = iOSUIKitViewControllerFactory(
            options: options,
            correctAnswers: correctAnswers
        )
        let router = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        quiz = Quiz.start(
            questions: questions,
            delegate: router
        )
    }
    
    private func startNewSwiftUIQuiz() {
        let questions = demoQuiz.questions
        let options = demoQuiz.options
        let correctAnswers = demoQuiz.correctAnswers
        
        let flow = iOSSwiftUINavigationFlowAdapter(
            navigator: navigationController,
            questions: questions,
            options: options,
            correctAnswers: correctAnswers,
            playAgain: startNewSwiftUIQuiz
        )
        
        quiz = Quiz.start(
            questions: questions,
            delegate: flow
        )
    }
    
}
