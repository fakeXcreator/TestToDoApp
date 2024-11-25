//
//  CheckBoxView.swift
//  TestToDo
//
//  Created by Daniil Kim on 19.11.2024.
//

import SwiftUI

struct CheckBoxView: View {
    // MARK: - Properties
    @Binding var isChecked: Bool

    // MARK: - View
    var body: some View {
        HStack {
            Button(action: {
                isChecked.toggle()
            }) {
                Image(systemName: isChecked ? "checkmark.circle" : "circle")
                    .foregroundColor(Color("TestYellow"))
                    .font(.system(size: 20))
            }
        }
    }
}

#Preview {
    @State var isCheckedPreview: Bool = false
    return CheckBoxView(isChecked: $isCheckedPreview)
}
