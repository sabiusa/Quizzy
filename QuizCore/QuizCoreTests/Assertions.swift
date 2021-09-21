//
//  Assertions.swift
//  QuizCoreTests
//
//  Created by Saba Khutsishvili on 21.09.21.
//

import Foundation
import XCTest

func assertEqual(
    _ a1: [(String, String)],
    _ a2: [(String, String)],
    file: StaticString = #filePath,
    line: UInt = #line
) {
    XCTAssertTrue(
        a1.elementsEqual(a2, by: ==),
        "\(a1) does not equal \(a2)",
        file: file,
        line: line
    )
}
