//
//  ResultsViewController.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 16.09.21.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet var headerLabel: UILabel!
    
    private var summary: String = ""
    
    convenience init(summary: String) {
        self.init()
        self.summary = summary
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = summary
    }
    
}
