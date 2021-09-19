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
        return "You go 1/2 correct"
    }
    
}
