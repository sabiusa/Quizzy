//
//  ResultsPresenter.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 19.09.21.
//

import QuizCore

struct ResultsPresenter {
    
    let result: QuizResult<Question<String>, [String]>
    
    var summary: String {
        return "You go \(result.score)/\(result.answers.count) correct"
    }
    
    var presentableAnswers: [PresentableAnswer] {
        return []
    }
    
}
