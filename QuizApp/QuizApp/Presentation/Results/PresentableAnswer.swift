//
//  PresentableAnswer.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 16.09.21.
//

import Foundation

struct PresentableAnswer: Equatable {
    let question: String
    let correctAnswer: String
    let wrongAnswer: String?
}
