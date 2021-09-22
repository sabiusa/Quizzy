//
//  View+Snapshot.swift
//  QuizAppTests
//
//  Created by Saba Khutsishvili on 22.09.21.
//

import SwiftUI

extension View {
    
    func snapshot(for configuration: SnapshotConfiguration = .iPhone8()) -> UIImage {
        let host = UIHostingController(rootView: self)
        return SnapshotWindow(configuration: configuration, root: host).snapshot()
    }
    
}
