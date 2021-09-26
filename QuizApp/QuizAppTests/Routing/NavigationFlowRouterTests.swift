//
//  NavigationFlowRouterTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 25.09.21.
//

import XCTest
import QuizCore

@testable import QuizApp

class NavigationFlowRouter  {
    
    private let navigator: UINavigationController
    private let factory: ViewControllerFactory
    
    init(
        navigator: UINavigationController,
        factory: ViewControllerFactory
    ) {
        self.navigator = navigator
        self.factory = factory
    }
    
    func answer(
        for question: Question<String>,
        completion: @escaping ([String]) -> Void
    ) {
        let controller = factory.questionViewController(
            for: question,
            answerCallback: completion
        )
        navigator.setViewControllers([controller], animated: true)
    }
    
}

class NavigationFlowRouterTests: XCTestCase {
    
    func test_answerForQuestion_showsQuestionController() {
        let vc1 = UIViewController()
        let question = singleAnswerQuestion
        
        let (sut, navigator, factory) = makeSUT()
        XCTAssertEqual(navigator.viewControllers.count, 0)
        
        factory.stub(for: question, with: vc1)
        sut.answer(for: question, completion: { _ in })
        
        XCTAssertEqual(navigator.viewControllers.count, 1)
        XCTAssertEqual(navigator.viewControllers.first, vc1)
    }
    
    // MARK:- Helpers
    
    private let singleAnswerQuestion = Question.singleAnswer("Q1")
    private let multipleAnswerQuestion = Question.multipleAnswer("Q2")
    
    private func makeSUT() -> (
        NavigationFlowRouter,
        NonAnimatedNavigationController,
        ViewControllerFactoryStub
    ) {
        let navigationController = NonAnimatedNavigationController()
        let factory = ViewControllerFactoryStub()
        let sut = NavigationFlowRouter(
            navigator: navigationController,
            factory: factory
        )
        return (sut, navigationController, factory)
    }
    
    private class ViewControllerFactoryStub: ViewControllerFactory {
        
        private var stubbedQuestions = [Question<String>: UIViewController]()
        
        func questionViewController(
            for question: Question<String>,
            answerCallback: @escaping ([String]) -> Void
        ) -> UIViewController {
            let controller = stubbedQuestions[question] ?? UIViewController()
            return controller
        }
        
        func resultViewController(for userAnswers: Answers) -> UIViewController {
            return UIViewController()
        }
        
        func stub(
            for question: Question<String>,
            with viewController: UIViewController
        ) {
            stubbedQuestions[question] = viewController
        }
        
    }
    
}
