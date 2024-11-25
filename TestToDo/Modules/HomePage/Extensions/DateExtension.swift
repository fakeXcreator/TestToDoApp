//
//  DateExtension.swift
//  TestToDo
//
//  Created by Daniil Kim on 19.11.2024.
//

import Foundation

extension Date {
    func toFormattedString(format: String = "dd/MM/yy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
