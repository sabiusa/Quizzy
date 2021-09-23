//
//  NonAnimatedNavigationController.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 23.09.21.
//

import UIKit

class NonAnimatedNavigationController: UINavigationController {
    
    override func setViewControllers(
        _ viewControllers: [UIViewController],
        animated: Bool
    ) {
        super.setViewControllers(viewControllers, animated: false)
    }
    
    override func pushViewController(
        _ viewController: UIViewController,
        animated: Bool
    ) {
        super.pushViewController(viewController, animated: false)
    }
    
}
