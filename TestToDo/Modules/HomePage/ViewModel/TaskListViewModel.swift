//
//  TaskListViewModel.swift
//  TestToDo
//
//  Created by Daniil Kim on 21.11.2024.
//

import Foundation
import CoreData
import SwiftUI

class TaskListViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = []
    @Published var filteredTasks: [TaskItem] = []
    @Published var searchText = ""
    @Published var selectedTask: TaskItem? = nil
    @Published var isLongPressed: Bool = false
    @Published var isEditingTask: Bool = false
    @Published var isTaskSaved: Bool = false
    
    private let apiViewModel: APIViewModel
    private let persistenceController: PersistenceController

    init(apiViewModel: APIViewModel, persistenceController: PersistenceController) {
        self.apiViewModel = apiViewModel
        self.persistenceController = persistenceController
        fetchTasks()
    }
    
    // MARK: - Methods
    func fetchTasks() {
        DispatchQueue.global(qos: .background).async {
            let fetchedTasks = self.persistenceController.fetchTasks()
            DispatchQueue.main.async {
                print("Fetched tasks: \(fetchedTasks.count)")
                self.tasks = fetchedTasks
                self.filteredTasks = fetchedTasks
            }
        }
    }
    
    func saveTasksToCoreData(from apiTasks: [APIModel]) {
        let context = self.persistenceController.container.viewContext

        DispatchQueue.global(qos: .background).async {
            for task in apiTasks {
                let newTask = TaskItem(context: context)

                if newTask.date == nil {
                    newTask.date = Date()
                }

                newTask.id = Int64(task.id)
                newTask.name = task.todo
                newTask.desc = task.todo
            }

            do {
                try context.save()

                DispatchQueue.main.async {
                    self.fetchTasks()
                    self.isTaskSaved = true
                }
            } catch {
                print("Failed to save tasks to Core Data: \(error)")
                DispatchQueue.main.async {
                    self.isTaskSaved = false
                }
            }
        }
    }

    func filterTasks() {
        DispatchQueue.global(qos: .background).async {
            if self.searchText.isEmpty {
                DispatchQueue.main.async {
                    self.filteredTasks = self.tasks
                }
            } else {
                let filtered = self.tasks.filter { $0.name?.localizedCaseInsensitiveContains(self.searchText) == true }
                DispatchQueue.main.async {
                    self.filteredTasks = filtered
                }
            }
        }
    }

    func updateIsChecked(for task: TaskItem, to newValue: Bool) {
        task.isChecked = newValue
        persistenceController.saveContext()
        filterTasks()
    }
    
    func createIsCheckedBinding(for task: TaskItem) -> Binding<Bool> {
        Binding(
            get: { task.isChecked },
            set: { [weak self] newValue in
                self?.updateIsChecked(for: task, to: newValue)
            }
        )
    }
    
    func closeSelectedTask() {
        DispatchQueue.main.async {
            self.selectedTask = nil
            self.isLongPressed = false
            self.isEditingTask = false
        }
    }
    
    func deleteTask(_ task: TaskItem) {
        let context = persistenceController.container.viewContext
        withAnimation {
            context.delete(task)
            do {
                try context.save()
                self.tasks.removeAll { $0 == task }
                self.filteredTasks.removeAll { $0 == task }
                self.closeSelectedTask()
            } catch {
                print("Failed to delete task: \(error)")
            }
        }
    }
    
    func openTaskForEditing(_ task: TaskItem) {
        DispatchQueue.main.async {
            withAnimation{
                self.selectedTask = task
                self.isEditingTask = true
                self.isLongPressed = false
            }
        }
        print("Selected Task for Editing: \(task.id)")
    }
}
