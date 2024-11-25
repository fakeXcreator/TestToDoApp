//
//  AdditionalButtonsView.swift
//  TestToDo
//
//  Created by Daniil Kim on 22.11.2024.
//

import SwiftUI

struct AdditionalButtonsView: View {
    // MARK: - Properties
    @StateObject private var viewModel: TaskListViewModel
    var task: TaskItem
    
    init(viewModel: TaskListViewModel, task: TaskItem) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.task = task
    }
    
    // MARK: - View
    var body: some View {
        VStack {
            edit
            separator
            share
            separator
            delete
        }
        .background(
            Color("TestButton")
                .cornerRadius(12)
        )
        .padding(.horizontal, 53)
    }
}

// MARK: - UI Components
private extension AdditionalButtonsView {
    
    var edit: some View {
        HStack {
            Button(action: {
                withAnimation {
                    do {
                        try viewModel.openTaskForEditing(task)
                        print("Task for editing: \(task.id)")
                    } catch {
                        print("Error opening task for editing: \(error.localizedDescription)")
                    }
                }
            }) {
                HStack {
                    Text("Редактировать")
                    Spacer()
                    Image("editIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 19, height: 19)
                }
            }
            .buttonStyle(ActionButtonModifier())
        }
    }
    
    var share: some View {
        HStack {
            Button(action: {
            }) {
                HStack {
                    Text("Поделиться")
                    Spacer()
                    Image("shareIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 19, height: 19)
                }
            }
            .buttonStyle(ActionButtonModifier())
        }
    }
    
    var delete: some View {
        HStack {
            Button(action: {
                viewModel.deleteTask(task)
            }) {
                HStack {
                    Text("Удалить")
                    Spacer()
                    Image("deleteIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 19, height: 19)
                }
                .foregroundColor(Color(.systemRed))
            }
            .buttonStyle(ActionButtonModifier())
        }
    }
    
    var separator: some View {
        SeparatorView()
    }
}

// MARK: - Modifier
struct ActionButtonModifier: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17))
            .padding(.horizontal, 16)
            .padding(.vertical, 11)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color("TestButton"))
            .cornerRadius(12)
            .foregroundColor(Color("TestGray"))
            .animation(.easeInOut(duration: 0.5), value: configuration.isPressed)
            .contentShape(Rectangle())
    }
}
