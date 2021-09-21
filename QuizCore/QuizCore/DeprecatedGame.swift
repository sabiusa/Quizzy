//
//  DeprecatedGame.swift
//  QuizCore
//
//  Created by Saba Khutsishvili on 16.09.21.
//

import Foundation

@available(*, deprecated, message: "use QuizDelegate instead")
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
public struct QuizResult<Question: Hashable, Answer> {
    
    public let answers: [Question: Answer]
    public let score: Int
    
}

@available(*, deprecated, message: "use Quiz instead")
public class Game<Question, Answer, R: Router> {
    
    let flow: Any
    
    init(flow: Any) {
        self.flow = flow
    }
    
}

@available(*, deprecated, message: "use Quiz.start instead")
public func startGame<Question, Answer: Equatable, R: Router>(
    questions: [Question],
    router: R,
    correctAnswers: [Question: Answer]
) -> Game<Question, Answer, R>
where R.Question == Question,
      R.Answer == Answer
{
    let delegate = QuizDelegateToRouterAdapter(router, correctAnswers)
    let flow = Flow(questions: questions, delegate: delegate)
    let game: Game<R.Question, R.Answer, R> = Game(flow: flow)
    flow.start()
    return game
}

@available(*, deprecated, message: "remove")
private class QuizDelegateToRouterAdapter<R: Router>: QuizDelegate
where R.Answer: Equatable {
    
    private let router: R
    private let correctAnswers: [R.Question: R.Answer]
    
    init(_ router: R, _ correctAnswers: [R.Question: R.Answer]) {
        self.router = router
        self.correctAnswers = correctAnswers
    }
    
    func answer(
        for question: R.Question,
        completion: @escaping (R.Answer) -> Void
    ) {
        router.route(to: question, answerCallback: completion)
    }
    
    func didCompleteQuiz(with answers: [(question: R.Question, answer: R.Answer)]) {
        let userAnswers = answers.reduce(into: [R.Question: R.Answer]()) { acc, tuple in
            return acc[tuple.question] = tuple.answer
        }
        let score = scoring(answers: userAnswers, correctAnswers: correctAnswers)
        let result = QuizResult(answers: userAnswers, score: score)
        router.route(to: result)
    }
        
    private func scoring(
        answers: [R.Question: R.Answer],
        correctAnswers: [R.Question: R.Answer]
    ) -> Int {
        return answers.reduce(0) { score, kvp in
            let current = correctAnswers[kvp.key] == kvp.value ? 1 : 0
            return score + current
        }
    }
    
}
