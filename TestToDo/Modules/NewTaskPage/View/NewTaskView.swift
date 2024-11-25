//
//  NewTaskView.swift
//  TestToDo
//
//  Created by Daniil Kim on 19.11.2024.
//

import SwiftUI

struct NewTaskView: View {
    // MARK: - Properties
    @StateObject private var viewModel: NewTaskViewModel
    @Environment(\.presentationMode) var presentationMode
    var taskListViewModel: TaskListViewModel
    @Binding var isTaskSaved: Bool
    
    init(viewModel: NewTaskViewModel, taskListViewModel: TaskListViewModel, isTaskSaved: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.taskListViewModel = taskListViewModel
        _isTaskSaved = isTaskSaved
    }
    
    // MARK: - View
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(spacing: 8) {
                title
                date
            }
            description
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .frame(maxHeight: .infinity, alignment: .top)
        .onDisappear {
            viewModel.saveTask(to: taskListViewModel)
            self.isTaskSaved = true
        }
    }
}

// MARK: - UI Components
private extension NewTaskView {
    var title: some View {
        TextField("Title", text: $viewModel.title)
            .font(.system(size: 34))
            .foregroundColor(Color("TestWhite"))
    }
    
    var date: some View {
        Text(viewModel.formattedDate)
            .font(.system(size: 12))
            .foregroundColor(Color("TestWhite"))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var description: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $viewModel.description)
                .font(.system(size: 16))
                .foregroundColor(Color("TestWhite"))
                .offset(x: -5, y: -8)
            if viewModel.description.isEmpty {
                Text("Description")
                    .font(.system(size: 16))
                    .foregroundColor(Color.gray)
            }
        }
    }
}


