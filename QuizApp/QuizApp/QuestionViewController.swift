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
    
    private(set) var question = ""
    private(set) var options = [String]()
    private(set) var allowsMultipleSelection = false
    private var selection: (([String]) -> Void)? = nil
    private let cellIdentifier = "Cell"
    
    convenience init(
        question: String,
        options: [String],
        allowsMultipleSelection: Bool,
        selection: @escaping ([String]) -> Void
    ) {
        self.init()
        self.question = question
        self.options = options
        self.allowsMultipleSelection = allowsMultipleSelection
        self.selection = selection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = question
        tableView.allowsMultipleSelection = allowsMultipleSelection
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
        selection?(selectedOptions(in: tableView))
    }
    
    func tableView(
        _ tableView: UITableView,
        didDeselectRowAt indexPath: IndexPath
    ) {
        if tableView.allowsMultipleSelection {
            selection?(selectedOptions(in: tableView))
        }
    }
    
    private func selectedOptions(in tableView: UITableView) -> [String] {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows
        else { return [] }
        
        return selectedIndexPaths.map { options[$0.row] }
    }
    
    private func dequeueCell(in tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    }
    
}
