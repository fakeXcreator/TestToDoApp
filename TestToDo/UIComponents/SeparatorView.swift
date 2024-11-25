//
//  SeparatorView.swift
//  TestToDo
//
//  Created by Daniil Kim on 17.11.2024.
//

import SwiftUI

struct SeparatorView: View {
    // MARK: - Properties
    var color: Color = Color("TestStroke")
    var height: CGFloat = 1

    // MARK: - View
    var body: some View {
        Rectangle()
            .frame(height: height)
            .foregroundColor(color)
    }
}

#Preview {
    SeparatorView()
}
