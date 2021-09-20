//
//  Game.swift
//  QuizCore
//
//  Created by Saba Khutsishvili on 16.09.21.
//

import Foundation

@available(*, deprecated)
public class Game<Question, Answer, R: Router>
where R.Question == Question,
      R.Answer == Answer {
    
    let flow: Flow<R>
    
    init(flow: Flow<R>) {
        self.flow = flow
    }
    
}

@available(*, deprecated)
public func startGame<Question, Answer: Equatable, R: Router>(
    questions: [Question],
    router: R,
    correctAnswers: [Question: Answer]
) -> Game<Question, Answer, R>
where R.Question == Question, R.Answer == Answer {
    let flow = Flow(
        questions: questions,
        router: router,
        scoring: { answers in
            scoring(
                answers: answers,
                correctAnswers: correctAnswers
            )
        }
    )
    let game = Game(flow: flow)
    game.flow.start()
    return game
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
