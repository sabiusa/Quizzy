//
//  QuestionViewController.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 15.09.21.
//

import Foundation
import UIKit

class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    private var question = ""
    private var options = [String]()
    private var selection: (([String]) -> Void)? = nil
    private let cellIdentifier = "Cell"
    
    convenience init(
        question: String,
        options: [String],
        selection: @escaping ([String]) -> Void
    ) {
        self.init()
        self.question = question
        self.options = options
        self.selection = selection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = question
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return options.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = dequeueCell(in: tableView)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let selected = tableView.indexPathsForSelectedRows!.map { options[$0.row] }
        selection?(selected)
    }
    
    private func dequeueCell(in tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    }
    
}
