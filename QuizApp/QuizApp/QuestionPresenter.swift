//
//  QuestionPresenter.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 19.09.21.
//

import Foundation

struct QuestionPresenter {
    
    let allQuestions: [Question<String>]
    let currentQuestion: Question<String>
    
    var title: String {
        return "Question #1"
    }
    
}
