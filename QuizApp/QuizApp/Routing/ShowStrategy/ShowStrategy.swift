//
//  ShowStrategy.swift
//  QuizApp
//
//  Created by Saba Khutsishvili on 23.09.21.
//

import UIKit

protocol ShowStrategy {
    
    func show(_ viewController: UIViewController)
    
}

extension ShowStrategy {
    
    func callAsFunction(_ viewController: UIViewController) {
        show(viewController)
    }
    
}

struct PushStrategy: ShowStrategy {
    
    let navigationController: UINavigationController
    
    func show(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
    
}

struct ReplaceStrategy: ShowStrategy {
    
    let navigationController: UINavigationController
    
    func show(_ viewController: UIViewController) {
        navigationController.setViewControllers([viewController], animated: true)
    }
    
}
