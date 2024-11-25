//
//  TaskListView.swift
//  TestToDo
//
//  Created by Daniil Kim on 17.11.2024.
//

import SwiftUI

struct TaskListView: View {
    // MARK: - Properties
    @StateObject private var viewModel: TaskListViewModel
    @State private var isTaskSaved: Bool = false

    init(viewModel: TaskListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - View
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    search
                    list
                    footer
                }
                .navigationTitle("Задачи")
                .blur(radius: viewModel.isLongPressed ? 5 : 0)
                .disabled(viewModel.isLongPressed)

                // MARK: - onLongPressGesture
                if let task = viewModel.selectedTask, viewModel.isLongPressed {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                viewModel.closeSelectedTask()
                            }

                        VStack(spacing: 16) {
                            TaskCellView(
                                isChecked: .constant(false),
                                viewModel: NewTaskViewModel(task: task),
                                taskListViewModel: viewModel,
                                showCheckBox: !(task == viewModel.selectedTask && viewModel.isLongPressed)
                            )
                            .padding()
                            .background(Color("TestGray"))
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .scaleEffect(1.1)
                            .padding(.horizontal, 20)

                            AdditionalButtonsView(viewModel: viewModel, task: task)
                                .zIndex(1)
                        }
                        .padding(.horizontal, 20)
                    }
                    .zIndex(1)
                }

                // MARK: - Edit Task View
                if let task = viewModel.selectedTask {
                    NavigationLink(
                        destination: NewTaskView(viewModel: NewTaskViewModel(task: task), taskListViewModel: viewModel, isTaskSaved: $isTaskSaved),
                        isActive: Binding(
                            get: {
                                return viewModel.isEditingTask
                            },
                            set: { newValue in
                                if !newValue {
                                    viewModel.closeSelectedTask()
                                }
                            }
                        )
                    ) {
                        EmptyView()
                    }
                }
            }
        }
        .tint(Color("TestYellow"))
        .onChange(of: isTaskSaved) { _ in
            if isTaskSaved {
                viewModel.fetchTasks()
                isTaskSaved = false  
            }
        }
    }
}

// MARK: - UI Components
private extension TaskListView {
    var search: some View {
        SearchField(text: $viewModel.searchText)
            .padding(.top, 8)
            .padding(.bottom, 16)
            .onChange(of: viewModel.searchText) { _ in
                viewModel.filterTasks()
            }
    }

    var list: some View {
        ScrollView {
            VStack(spacing: 6) {
                ForEach($viewModel.filteredTasks, id: \.self) { $task in
                    TaskCellView(
                        isChecked: viewModel.createIsCheckedBinding(for: task),
                        viewModel: NewTaskViewModel(task: task),
                        taskListViewModel: viewModel
                    )
                    .onLongPressGesture {
                        withAnimation {
                            viewModel.selectedTask = task
                            viewModel.isLongPressed = true
                        }
                    }
                    if task != viewModel.filteredTasks.last {
                        SeparatorView()
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            viewModel.fetchTasks()
        }
    }

    var footer: some View {
        FooterView(taskListViewModel: viewModel)
    }
}
