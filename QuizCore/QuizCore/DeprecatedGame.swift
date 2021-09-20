//
//  DeprecatedGame.swift
//  QuizCore
//
//  Created by Saba Khutsishvili on 16.09.21.
//

import Foundation

@available(*, deprecated)
public protocol Router {
    
    associatedtype Question: Hashable
    associatedtype Answer
    
    func route(
        to question: Question,
        answerCallback: @escaping (Answer) -> Void
    )
    
    func route(to result: QuizResult<Question, Answer>)
    
}

@available(*, deprecated)
public class Game<Question, Answer, R: Router> {
    
    let flow: Any
    
    init(flow: Any) {
        self.flow = flow
    }
    
}

@available(*, deprecated)
public func startGame<Question, Answer: Equatable, R: Router>(
    questions: [Question],
    router: R,
    correctAnswers: [Question: Answer]
) -> Game<Question, Answer, R>
where R.Question == Question,
      R.Answer == Answer
{
    let flow = Flow(
        questions: questions,
        delegate: QuizDelegateToRouterAdapter(router),
        scoring: { answers in
            scoring(
                answers: answers,
                correctAnswers: correctAnswers
            )
        }
    )
    let game: Game<R.Question, R.Answer, R> = Game(flow: flow)
    flow.start()
    return game
}

@available(*, deprecated)
private class QuizDelegateToRouterAdapter<R: Router>: QuizDelegate {
    
    private let router: R
    
    init(_ router: R) {
        self.router = router
    }
    
    func answer(
        for question: R.Question,
        completion: @escaping (R.Answer) -> Void
    ) {
        router.route(to: question, answerCallback: completion)
    }
    
    func handle(
        result: QuizResult<R.Question, R.Answer>
    ) {
        router.route(to: result)
    }
    
}
