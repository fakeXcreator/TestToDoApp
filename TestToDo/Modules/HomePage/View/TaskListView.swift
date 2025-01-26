//  TaskListView.swift
//  TestToDo
//
//  Created by Daniil Kim on 17.11.2024.
//

import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel: TaskListViewModel
    @State private var isTaskSaved: Bool = false
    private let persistenceController: PersistenceController
    
    init(viewModel: TaskListViewModel, persistenceController: PersistenceController) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.persistenceController = persistenceController
    }

    var body: some View {
        NavigationView {
            ZStack {
                content
                longPressOverlay
                editTaskView
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
    var content: some View {
        VStack {
            search
            list
            footer
        }
        .navigationTitle("Задачи")
        .blur(radius: viewModel.isLongPressed ? 5 : 0)
        .disabled(viewModel.isLongPressed)
    }

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
                        viewModel: NewTaskViewModel(task: task, persistenceController: persistenceController),
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
        FooterView(taskListViewModel: viewModel, persistenceController: persistenceController)
    }

    var longPressOverlay: some View {
        if let task = viewModel.selectedTask, viewModel.isLongPressed {
            return AnyView(
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            viewModel.closeSelectedTask()
                        }

                    VStack(spacing: 16) {
                        TaskCellView(
                            isChecked: .constant(false),
                            viewModel: NewTaskViewModel(task: task, persistenceController: persistenceController),
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
            )
        } else {
            return AnyView(EmptyView())
        }
    }

    var editTaskView: some View {
        if let task = viewModel.selectedTask {
            return AnyView(
                NavigationLink(
                    destination: NewTaskView(
                        viewModel: NewTaskViewModel(task: task, persistenceController: persistenceController),
                        taskListViewModel: viewModel,
                        isTaskSaved: $isTaskSaved
                    ),
                    isActive: Binding(
                        get: { viewModel.isEditingTask },
                        set: { newValue in
                            if !newValue {
                                viewModel.closeSelectedTask()
                            }
                        }
                    )
                ) {
                    EmptyView()
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
}
