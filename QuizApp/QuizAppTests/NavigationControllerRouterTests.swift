//
//  NavigationControllerRouterTests.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 16.09.21.
//

import XCTest

@testable import QuizCore
@testable import QuizApp

class NavigationControllerRouterTests: XCTestCase {
    
    let navigationController = NonAnimatedNavigationController()
    let factory = ViewControllerFactoryStub()
    
    func test_routeToQuestion_showsQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        factory.stub(question: Question.singleAnswer("Q1"), with: viewController)
        factory.stub(question: Question.singleAnswer("Q2"), with: secondViewController)
        
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        sut.route(to: Question.singleAnswer("Q1"), answerCallback: { _ in })
        sut.route(to: Question.singleAnswer("Q2"), answerCallback: { _ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_presentsQuestionControllerWithRightCallback() {
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        var callbackWasFired = false
        sut.route(to: Question.singleAnswer("Q1"), answerCallback: { _ in callbackWasFired = true })
        factory.fireCallback(for: Question.singleAnswer("Q1"))
        
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_routeToResult_showsResultController() {
        let viewController = UIViewController()
        let result = QuizResult(answers: [Question.singleAnswer("Q1"): ["A1"]], score: 10)
        
        let secondViewController = UIViewController()
        let secondResult = QuizResult(answers: [Question.singleAnswer("Q2"): ["A2"]], score: 20)
        
        factory.stub(result: result, with: viewController)
        factory.stub(result: secondResult, with: secondViewController)
        
        let sut = NavigationControllerRouter(
            navigationController,
            factory: factory
        )
        
        sut.route(to: result)
        sut.route(to: secondResult)
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    // MARK:- Helpers
    
    class NonAnimatedNavigationController: UINavigationController {
        
        override func pushViewController(
            _ viewController: UIViewController,
            animated: Bool
        ) {
            super.pushViewController(viewController, animated: false)
        }
        
    }
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        
        private var stubbedQuestions = [Question<String>: UIViewController]()
        private var stubbedResults = [QuizResult<Question<String>, [String]>: UIViewController]()
        private var answerCallbacks = [Question<String>: ([String]) -> Void]()
        
        func questionViewController(
            for question: Question<String>,
            answerCallback: @escaping ([String]) -> Void
        ) -> UIViewController {
            answerCallbacks[question] = answerCallback
            let viewController = stubbedQuestions[question] ?? UIViewController()
            return viewController
        }
        
        func resultViewController(
            for result: QuizResult<Question<String>, [String]>
        ) -> UIViewController {
            return stubbedResults[result] ?? UIViewController()
        }
        
        func stub(
            question: Question<String>,
            with viewController: UIViewController
        ) {
            stubbedQuestions[question] = viewController
        }
        
        func stub(
            result: QuizResult<Question<String>, [String]>,
            with viewController: UIViewController
        ) {
            stubbedResults[result] = viewController
        }
        
        func fireCallback(
            for question: Question<String>,
            with answers: [String] = []
        ) {
            answerCallbacks[question]?(answers)
        }
        
    }
    
}

extension QuizResult {
    
    static func make(
        answers: [Question: Answer],
        score: Int
    ) -> QuizResult {
        return QuizResult(answers: answers, score: score)
    }
    
}
 
extension QuizResult: Equatable where Answer: Equatable {
    
    public static func ==(
        lhs: QuizResult<Question, Answer>,
        rhs: QuizResult<Question, Answer>
    ) -> Bool {
        return
            lhs.score == rhs.score &&
            lhs.answers == rhs.answers
    }
    
}

extension QuizResult: Hashable where Answer: Equatable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(answers.map(\.key))
    }
    
}
