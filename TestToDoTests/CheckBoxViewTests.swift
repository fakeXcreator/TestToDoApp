//
//  CheckBoxViewTests.swift
//  TestToDoTests
//
//  Created by Daniil Kim on 24.11.2024.
//

import XCTest
import SwiftUI
@testable import TestToDo

class CheckBoxViewTests: XCTestCase {

    func testCheckBox_toggleState() {
        var isChecked = false
        let binding = Binding(
            get: { isChecked },
            set: { isChecked = $0 }
        )
        
        let checkBoxView = CheckBoxView(isChecked: binding)
        
        isChecked.toggle()
        XCTAssertTrue(isChecked, "isChecked should be true after toggling")
        
        isChecked.toggle()
        XCTAssertFalse(isChecked, "isChecked should be false after toggling again")
    }
}
