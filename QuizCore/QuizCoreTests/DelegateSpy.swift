//
//  DelegateSpy.swift
//  QuizCoreTests
//
//  Created by Saba Khutsishvili on 21.09.21.
//

import Foundation
import QuizCore

class DelegateSpy: QuizDelegate {
    
    var askedQuestions = [String]()
    var answerCompletions: [(String) -> Void] = []
    var completedQuizzes: [[(String, String)]] = []
    
    var handledQuestionCount: Int {
        return askedQuestions.count
    }
    
    func answer(for question: String, completion: @escaping (String) -> Void) {
        self.askedQuestions.append(question)
        self.answerCompletions.append(completion)
    }
    
    func didCompleteQuiz(with answers: [(question: String, answer: String)]) {
        completedQuizzes.append(answers)
    }
    
}
