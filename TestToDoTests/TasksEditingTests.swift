//
//  TasksEditingTests.swift
//  TestToDoTests
//
//  Created by Daniil Kim on 25.11.2024.
//

import XCTest
import SwiftUI
@testable import TestToDo

class TaskEditingTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    var taskListViewModel: TaskListViewModel!
    var apiViewModel: APIViewModel!
    
    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        
        apiViewModel = APIViewModel()
        
        taskListViewModel = TaskListViewModel(apiViewModel: apiViewModel, persistenceController: persistenceController)
    }
    
    override func tearDownWithError() throws {
        persistenceController = nil
        taskListViewModel = nil
        apiViewModel = nil
    }
    
    func testSaveTaskToCoreData() {
        let newTask = TaskItem(context: persistenceController.container.viewContext)
        newTask.id = 1
        newTask.name = "Test Task"
        newTask.desc = "Test Task Description"
        newTask.date = Date()
        
        persistenceController.saveContext()
        
        let fetchedTasks = persistenceController.fetchTasks()
        XCTAssertEqual(fetchedTasks.count, 1, "Task should be saved to CoreData")
        
        let fetchedTask = fetchedTasks.first
        XCTAssertEqual(fetchedTask?.name, "Test Task", "Task name should match")
        XCTAssertEqual(fetchedTask?.desc, "Test Task Description", "Task description should match")
    }
    
    func testEditTask() {
        let newTask = TaskItem(context: persistenceController.container.viewContext)
        newTask.id = 1
        newTask.name = "Old Task Name"
        newTask.desc = "Old Task Description"
        newTask.date = Date()
        
        persistenceController.saveContext()
        
        var fetchedTasks = persistenceController.fetchTasks()
        let taskToEdit = fetchedTasks.first
        XCTAssertNotNil(taskToEdit, "Task should be fetched from CoreData")
        
        taskToEdit?.name = "Updated Task Name"
        taskToEdit?.desc = "Updated Task Description"
        
        persistenceController.saveContext()
        
        fetchedTasks = persistenceController.fetchTasks()
        let updatedTask = fetchedTasks.first
        XCTAssertEqual(updatedTask?.name, "Updated Task Name", "Task name should be updated")
        XCTAssertEqual(updatedTask?.desc, "Updated Task Description", "Task description should be updated")
    }
    
    func testSaveNewTaskView() {
        let newTaskViewModel = NewTaskViewModel(persistenceController: persistenceController)
        newTaskViewModel.title = "New Task"
        newTaskViewModel.description = "This is a new task"
        
        let taskListViewModel = TaskListViewModel(apiViewModel: apiViewModel, persistenceController: persistenceController)
        newTaskViewModel.saveTask(to: taskListViewModel)
        
        let fetchedTasks = persistenceController.fetchTasks()
        XCTAssertEqual(fetchedTasks.count, 1, "Task should be saved")
        
        let task = fetchedTasks.first
        XCTAssertEqual(task?.name, "New Task", "Task name should match")
        XCTAssertEqual(task?.desc, "This is a new task", "Task description should match")
    }
    
    func testEditTaskView() {
        let newTask = TaskItem(context: persistenceController.container.viewContext)
        newTask.id = 1
        newTask.name = "Old Task"
        newTask.desc = "Old Description"
        newTask.date = Date()
        
        persistenceController.saveContext()
        
        let newTaskViewModel = NewTaskViewModel(task: newTask, persistenceController: persistenceController)
        newTaskViewModel.title = "Updated Task"
        newTaskViewModel.description = "Updated Description"
        
        newTaskViewModel.saveTask(to: taskListViewModel)
        
        let fetchedTasks = persistenceController.fetchTasks()
        XCTAssertEqual(fetchedTasks.count, 1, "There should be one task after editing")
        
        let updatedTask = fetchedTasks.first
        XCTAssertEqual(updatedTask?.name, "Updated Task", "The task name should be updated")
        XCTAssertEqual(updatedTask?.desc, "Updated Description", "The task description should be updated")
    }
}
