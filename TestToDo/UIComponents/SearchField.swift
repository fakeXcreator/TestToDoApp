//
//  SearchBarView.swift
//  TestToDo
//
//  Created by Daniil Kim on 18.11.2024.
//

import Foundation
import SwiftUI

struct SearchField: View {
    // MARK: - Properties
    let placeholder: String
    @Binding var text: String
    
    init(placeholder: String = "Search", text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    // MARK: - View
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color("TestStroke"))
            
            TextField("", text: $text, prompt: Text(placeholder))
                .foregroundColor(Color("TestWhite"))
                .font(.system(size: 17))
                .frame(maxWidth: .infinity)
            
            Image(systemName: "microphone")
                .foregroundColor(Color("TestStroke"))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal)
        .frame(height: 36)
        .background(Color("TestGray"))
        .cornerRadius(10)
        .padding(.horizontal, 20)
    }
}

#Preview {
    SearchField(text: .constant(""))
}
