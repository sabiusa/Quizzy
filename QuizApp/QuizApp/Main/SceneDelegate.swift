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
        
        startNewSwiftUIAdapterQuiz()
    }
    
    private func startNewUIKitQuiz() {
        let (questions, options, correctAnswers) = Questionnare.getQuizData()
        
        let factory = iOSUIKitViewControllerFactory(
            options: options,
            correctAnswers: correctAnswers
        )
        
        let router = NavigationControllerRouter(navigationController, factory: factory)
        
        quiz = Quiz.start(
            questions: questions,
            delegate: router
        )
    }
    
    private func startNewSwiftUIRouterQuiz() {
        let (questions, options, correctAnswers) = Questionnare.getQuizData()
        
        let factory = iOSSwiftUIViewControllerFactory(
            options: options,
            correctAnswers: correctAnswers,
            playAgain: startNewSwiftUIRouterQuiz
        )
        
        let router = NavigationControllerRouter(navigationController, factory: factory)
        
        quiz = Quiz.start(
            questions: questions,
            delegate: router
        )
    }
    
    private func startNewSwiftUIAdapterQuiz() {
        let (questions, options, correctAnswers) = Questionnare.getQuizData()
        let navigation = QuizNavigationStore()
        
        let adapter = iOSSwiftUINavigationStoreAdapter(
            navigation: navigation,
            options: options,
            correctAnswers: correctAnswers,
            playAgain: startNewSwiftUIAdapterQuiz
        )
        
        quiz = Quiz.start(
            questions: questions,
            delegate: adapter
        )
    }
    
}

enum Questionnare {
    
    typealias Data = (
        questions: [Question<String>],
        options: [Question<String> : [String]],
        correctAnswers: [(Question<String>, [String])]
    )
    
    static func getQuizData() -> Data {
        let question1 = Question.singleAnswer("What is 2x2?")
        let question2 = Question.multipleAnswer("How to get 8")
        let questions = [question1, question2]
        
        let option1 = "2", option2 = "4", option3 = "6"
        let options1 = [option1, option2, option3]
        
        let option4 = "3 + 5", option5 = "2 + 7", option6 = "5 + 5", option7 = "0 + 8"
        let options2 = [option4, option5, option6, option7]
        let options = [question1: options1, question2: options2]
        
        let correctAnswers = [
            (question1, [option2]),
            (question2, [option4, option7])
        ]
        
        return (questions, options, correctAnswers)
    }
    
}
