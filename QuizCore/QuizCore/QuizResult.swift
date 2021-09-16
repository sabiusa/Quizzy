//
//  QuizResult.swift
//  QuizCore
//
//  Created by Saba Khutsishvili on 16.09.21.
//

import Foundation

struct QuizResult<Question: Hashable, Answer> {
    
    let answers: [Question: Answer]
    let score: Int
    
}
