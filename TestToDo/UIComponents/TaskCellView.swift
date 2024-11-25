//
//  TaskCellView.swift
//  TestToDo
//
//  Created by Daniil Kim on 17.11.2024.
//

import SwiftUI

struct TaskCellView: View {
    // MARK: - Properties
    @Binding var isChecked: Bool
    @ObservedObject var viewModel: NewTaskViewModel
    @ObservedObject var taskListViewModel: TaskListViewModel
    var showCheckBox: Bool = true
    
    // MARK: - View
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if showCheckBox {
                CheckBoxView(isChecked: $isChecked)
                    .frame(width: 24, height: 24)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.title)
                    .font(.system(size: 16))
                    .foregroundColor(Color("TestWhite"))
                
                Text(viewModel.description)
                    .lineLimit(2)
                    .font(.system(size: 12))
                    .foregroundColor(Color("TestWhite"))
                
                Text(viewModel.formattedDate)
                    .font(.system(size: 12))
                    .foregroundColor(Color("TestWhite"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxHeight: 106)
        .padding(.horizontal, 20)
        .onChange(of: isChecked) { newValue in
            if let task = viewModel.task {
                taskListViewModel.updateIsChecked(for: task, to: newValue)
            }
        }
    }
}
