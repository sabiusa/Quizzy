//
//  Question.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 17.09.21.
//

import Foundation

enum Question<T: Hashable>: Hashable {
    case singleAnswer(T)
    case multipleAnswer(T)
}
