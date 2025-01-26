//
//  NewTaskViewModel.swift
//  TestToDo
//
//  Created by Daniil Kim on 19.11.2024.
//

import Foundation

final class NewTaskViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    private(set) var date: Date

    var task: TaskItem?
    private let persistenceController: PersistenceController

    init(task: TaskItem? = nil, persistenceController: PersistenceController) {
        self.task = task
        self.title = task?.name ?? ""
        self.description = task?.desc ?? ""
        self.date = task?.date ?? Date()
        self.persistenceController = persistenceController
    }
    
    // MARK: - Methods
    var formattedDate: String {
        date.toFormattedString()
    }
    
    func saveTask(to viewModel: TaskListViewModel) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("Task not saved: Title is empty")
            return
        }
        
        let context = persistenceController.container.viewContext

        if let task = self.task {
            task.name = self.title
            task.desc = self.description
            task.date = self.date
        } else {
            let newTask = TaskItem(context: context)
            newTask.id = Int64(Date().timeIntervalSince1970)
            newTask.name = self.title
            newTask.desc = self.description
            newTask.date = self.date
        }

        do {
            try context.save()
            
            DispatchQueue.main.async {
                viewModel.fetchTasks()
                print("Task saved successfully")
            }
        } catch {
            print("Failed to save task: \(error)")
        }
    }
}
