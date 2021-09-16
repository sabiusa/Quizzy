//
//  UITableView+Extensions.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 16.09.21.
//

import UIKit

extension UITableView {
    
    func register(_ type: UITableViewCell.Type) {
        let className = String(describing: type)
        register(
            UINib(nibName: className, bundle: nil),
            forCellReuseIdentifier: className
        )
    }
    
    func dequeueCell<T>(_ type: T.Type, for indexPath: IndexPath) -> T {
        let className = String(describing: type)
        let cell = dequeueReusableCell(withIdentifier: className, for: indexPath)
        return cell as! T
    }
}
