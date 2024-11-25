//
//  TasksEditingTests.swift
//  TestToDoTests
//
//  Created by Daniil Kim on 25.11.2024.
//

import XCTest
import CoreData
@testable import TestToDo

class TasksEditingTests: XCTestCase {
    var taskListViewModel: TaskListViewModel!
    var mockContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        mockContext = PersistenceController.shared.container.viewContext
        let apiViewModel = APIViewModel()
        taskListViewModel = TaskListViewModel(apiViewModel: apiViewModel)
    }
    
    func testUpdateTask() {
        let task = TaskItem(context: mockContext)
        task.name = "Old Task Name"
        task.desc = "Old Task Description"
        
        print("Before editing: \(task.name ?? "No Name")")
        
        taskListViewModel.openTaskForEditing(task)
        
        print("Selected Task for Editing: \(taskListViewModel.selectedTask?.name ?? "No Task Selected")")
        
        taskListViewModel.selectedTask?.name = "Updated Task Name"
        print("After editing: \(taskListViewModel.selectedTask?.name ?? "No Task Selected")")
        
        do {
            try mockContext.save()
            let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
            let tasks = try mockContext.fetch(fetchRequest)
            if let fetchedTask = tasks.first {
                print("Saved Task Name: \(fetchedTask.name ?? "No Name")")
            }
        } catch {
            XCTFail("Failed to save context: \(error)")
        }
    }
}
