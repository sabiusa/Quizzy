//
//  QuizResult.swift
//  QuizCore
//
//  Created by Saba Khutsishvili on 16.09.21.
//

import Foundation

public struct QuizResult<Question: Hashable, Answer> {
    
    public let answers: [Question: Answer]
    public let score: Int
    
}
