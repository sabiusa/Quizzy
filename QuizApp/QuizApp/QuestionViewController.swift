//
//  QuestionViewController.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 15.09.21.
//

import Foundation
import UIKit

class QuestionViewController: UIViewController {
    
    @IBOutlet var headerLabel: UILabel!
    
    private var question: String = ""
    
    convenience init(question: String) {
        self.init()
        self.question = question
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = question
    }
    
}
