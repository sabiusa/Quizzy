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
        let (questions, options, correctAnswers) = Questionnare.getQuizData()
        
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
        let (questions, options, correctAnswers) = Questionnare.getQuizData()
        
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

enum Questionnare {
    
    typealias Data = (
        questions: [Question<String>],
        options: [Question<String> : [String]],
        correctAnswers: [(Question<String>, [String])]
    )
    
    static func getQuizData() -> Data {
        let question1 = Question.singleAnswer("What is 2x2?")
        let question2 = Question.multipleAnswer("How to get 8")
        let question3 = Question.singleAnswer("What is the capital of Georgia")
        let questions = [question1, question2, question3]
        
        let option1 = "2", option2 = "4", option3 = "6"
        let options1 = [option1, option2, option3]
        
        let option4 = "3 + 5", option5 = "2 + 7", option6 = "5 + 5", option7 = "0 + 8"
        let options2 = [option4, option5, option6, option7]
        
        let option8 = "Tbilsi", option9 = "Mtskheta"
        let options3 = [option8, option9]
        
        let options = [
            question1: options1,
            question2: options2,
            question3: options3
        ]
        
        let correctAnswers = [
            (question1, [option2]),
            (question2, [option4, option7]),
            (question3, [option8])
        ]
        
        return (questions, options, correctAnswers)
    }
    
}
