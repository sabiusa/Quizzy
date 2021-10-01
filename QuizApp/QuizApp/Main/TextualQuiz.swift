//
//  TextualQuiz.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 01.10.21.
//

import QuizCore

let demoQuiz = try!
    TextualQuizBuilder(
        singleAnswerQuestion: "What is 2x2?",
        options: NonEmptyOptions(head: "2", tail: ["4", "6"]),
        answer: "4"
    )
    .adding(
        multipleAnswerQuestion: "How to get 8",
        options: NonEmptyOptions(head: "3 + 5", tail: ["2 + 7", "5 + 5", "0 + 8"]),
        answers: NonEmptyOptions(head: "3 + 5", tail: ["0 + 8"])
    )
    .adding(
        singleAnswerQuestion: "What is the capital of Georgia",
        options: NonEmptyOptions(head: "Tbilisi", tail: ["Batumi"]),
        answer: "Tbilisi"
    )
    .build()

public struct TextualQuiz {
    
    public let questions: [Question<String>]
    public let options: [Question<String>: [String]]
    public let correctAnswers: [(Question<String>, [String])]
    
}

public struct NonEmptyOptions {
    
    let head: String
    let tail: [String]
    
    var all: [String] { [head] + tail }
    
    public init(head: String, tail: [String]) {
        self.head = head
        self.tail = tail
    }
    
}

public struct TextualQuizBuilder {
    
    private var questions: [Question<String>] = []
    private var options: [Question<String>: [String]] = [:]
    private var correctAnswers: [(Question<String>, [String])] = []
    
    public enum AddingError: Error, Equatable {
        case duplicateQuestion(Question<String>)
        case duplicateOptions([String])
        case duplicateAnswers([String])
        case missingAnswerInOptions(answer: [String], options: [String])
    }
    
    private init(
        questions: [Question<String>],
        options: [Question<String> : [String]],
        correctAnswers: [(Question<String>, [String])]
    ) {
        self.questions = questions
        self.options = options
        self.correctAnswers = correctAnswers
    }
    
    public init(
        singleAnswerQuestion: String,
        options: NonEmptyOptions,
        answer: String
    ) throws {
        try add(
            singleAnswerQuestion: singleAnswerQuestion,
            options: options,
            answer: answer
        )
    }
    
    public init(
        multipleAnswerQuestion: String,
        options: NonEmptyOptions,
        answers: NonEmptyOptions
    ) throws {
        try add(
            multipleAnswerQuestion: multipleAnswerQuestion,
            options: options,
            answers: answers
        )
    }
    
    public mutating func add(
        multipleAnswerQuestion: String,
        options: NonEmptyOptions,
        answers: NonEmptyOptions
    ) throws {
        self = try adding(
            multipleAnswerQuestion: multipleAnswerQuestion,
            options: options,
            answers: answers
        )
    }
    
    public func adding(
        multipleAnswerQuestion: String,
        options: NonEmptyOptions,
        answers: NonEmptyOptions
    ) throws -> TextualQuizBuilder {
        let question = Question.multipleAnswer(multipleAnswerQuestion)
        let allOptions = options.all
        let allAnswers = answers.all
        
        guard Set(allAnswers).isSubset(of: Set(allOptions))
        else { throw AddingError.missingAnswerInOptions(answer: allAnswers, options: allOptions) }
        
        guard !questions.contains(question)
        else { throw AddingError.duplicateQuestion(question) }
        
        guard Set(allOptions).count == allOptions.count
        else { throw AddingError.duplicateOptions(allOptions) }
        
        guard Set(allAnswers).count == allAnswers.count
        else { throw AddingError.duplicateAnswers(allAnswers) }
        
        var newOptions = self.options
        newOptions[question] = allOptions
        
        return TextualQuizBuilder(
            questions: questions + [question],
            options: newOptions,
            correctAnswers: correctAnswers + [(question, allAnswers)]
        )
    }
    
    public mutating func add(
        singleAnswerQuestion: String,
        options: NonEmptyOptions,
        answer: String
    ) throws {
        self = try adding(
            singleAnswerQuestion: singleAnswerQuestion,
            options: options,
            answer: answer
        )
    }
    
    public func adding(
        singleAnswerQuestion: String,
        options: NonEmptyOptions,
        answer: String
    ) throws -> TextualQuizBuilder {
        let allOptions = options.all
        let question = Question.singleAnswer(singleAnswerQuestion)
        
        guard !questions.contains(question)
        else { throw AddingError.duplicateQuestion(question) }
        
        guard allOptions.contains(answer)
        else { throw AddingError.missingAnswerInOptions(answer: [answer], options: allOptions) }
        
        guard Set(allOptions).count == allOptions.count
        else { throw AddingError.duplicateOptions(allOptions) }
        
        var newOptions = self.options
        newOptions[question] = allOptions
        
        return TextualQuizBuilder(
            questions: questions + [question],
            options: newOptions,
            correctAnswers: correctAnswers + [(question, [answer])]
        )
    }
    
    public func build() -> TextualQuiz {
        return TextualQuiz(
            questions: questions,
            options: options,
            correctAnswers: correctAnswers
        )
    }
    
}
