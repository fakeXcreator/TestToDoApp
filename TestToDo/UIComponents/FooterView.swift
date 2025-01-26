//
//  FooterView.swift
//  TestToDo
//
//  Created by Daniil Kim on 18.11.2024.
//

import SwiftUI

struct FooterView: View {
    // MARK: - Properties
    @ObservedObject var taskListViewModel: TaskListViewModel
    @State private var isTaskSaved: Bool = false
    private let persistenceController: PersistenceController // Добавляем свойство для persistenceController
    
    // Инициализатор, который принимает persistenceController
    init(taskListViewModel: TaskListViewModel, persistenceController: PersistenceController) {
        self.taskListViewModel = taskListViewModel
        self.persistenceController = persistenceController // Инициализируем persistenceController
    }

    // MARK: - Fetch Request
    @FetchRequest(
        entity: TaskItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskItem.date, ascending: true)]
    ) var tasks: FetchedResults<TaskItem>
    
    // MARK: - View
    var body: some View {
        HStack {
            Text("")
                .frame(width: 68)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(taskListViewModel.tasks.count) Задач")
                .foregroundColor(Color("TestWhite"))
                .frame(maxWidth: .infinity, alignment: .center)
            
            NavigationLink(destination: NewTaskView(
                viewModel: NewTaskViewModel(persistenceController: persistenceController),
                taskListViewModel: taskListViewModel,
                isTaskSaved: $isTaskSaved
            )) {
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
            }
            .foregroundColor(Color("TestYellow"))
            .frame(width: 68)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 49)
        .background(Color("TestGray"))
    }
}
