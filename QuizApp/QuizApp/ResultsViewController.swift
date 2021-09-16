//
//  ResultsViewController.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 16.09.21.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    private var summary = ""
    private var answers = [PresentableAnswer]()
    
    convenience init(summary: String, answers: [PresentableAnswer]) {
        self.init()
        self.summary = summary
        self.answers = answers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = summary
        
        tableView.register(CorrectAnswerCell.self)
        tableView.register(WrongAnswerCell.self)
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return answers.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let answer = answers[indexPath.row]
        if answer.wrongAnswer == nil {
            return correctAnswerCell(for: answer, at: indexPath)
        } else {
            return wrongAnswerCell(for: answer, at: indexPath)
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 80
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func correctAnswerCell(
        for answer: PresentableAnswer,
        at indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueCell(CorrectAnswerCell.self, for: indexPath)
        cell.questionLabel.text = answer.question
        cell.answerLabel.text = answer.correctAnswer
        return cell
    }
    
    private func wrongAnswerCell(
        for answer: PresentableAnswer,
        at indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueCell(WrongAnswerCell.self, for: indexPath)
        cell.questionLabel.text = answer.question
        cell.correctAnswerLabel.text = answer.correctAnswer
        cell.wrongAnswerLabel.text = answer.wrongAnswer
        return cell
    }
    
}
