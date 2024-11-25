//
//  TextFieldView.swift
//  TestToDo
//
//  Created by Daniil Kim on 19.11.2024.
//

import SwiftUI

struct TextFieldView: View {
    // MARK: - Properties
    var placeholder: String
    @Binding var text: String
    
    // MARK: - View
    var body: some View {
        TextField(placeholder, text: $text)
            .modifier(TextFieldModifier())
    }
}

// MARK: Modifier
struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.leading, 15)
            .frame(maxWidth: .infinity, minHeight: 41)
            .cornerRadius(10)
            .foregroundColor(Color("TestWhite"))

    }
}

#Preview {
    @State var text = ""
    return TextFieldView(placeholder: "Title / Description", text: $text)
}
