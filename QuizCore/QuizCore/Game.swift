//
//  Game.swift
//  QuizCore
//
//  Created by Saba Khutsishvili on 16.09.21.
//

import Foundation

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
        router: QuizDelegateToRouterAdapter(router),
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
    
    func handle(
        question: R.Question,
        answerCallback: @escaping (R.Answer) -> Void
    ) {
        router.route(to: question, answerCallback: answerCallback)
    }
    
    func handle(
        result: QuizResult<R.Question, R.Answer>
    ) {
        router.route(to: result)
    }
    
}

private func scoring<Question, Answer: Equatable>(
    answers: [Question: Answer],
    correctAnswers: [Question: Answer]
) -> Int {
    return answers.reduce(0) { score, kvp in
        let current = correctAnswers[kvp.key] == kvp.value ? 1 : 0
        return score + current
    }
}
