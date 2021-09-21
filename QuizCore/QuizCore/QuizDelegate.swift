//
//  QuizDelegate.swift
//  QuizCore
//
//  Created by Saba Khutsishvili on 20.09.21.
//

import Foundation

public protocol QuizDelegate {
    
    associatedtype Question
    associatedtype Answer
    
    func answer(for question: Question, completion: @escaping (Answer) -> Void)
    func didCompleteQuiz(with answers: [(question: Question, answer: Answer)])
    
}
