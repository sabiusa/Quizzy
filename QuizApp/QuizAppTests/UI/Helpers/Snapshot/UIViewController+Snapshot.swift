//
//  UIViewController+Snapshot.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 22.09.21.
//

import UIKit

extension UIViewController {
    
    func snapshot(for configuration: SnapshotConfiguration = .iPhone8()) -> UIImage {
        return SnapshotWindow(configuration: configuration, root: self).snapshot()
    }
    
}
