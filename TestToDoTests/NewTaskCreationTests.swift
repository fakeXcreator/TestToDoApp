//
//  NewTaskCreationTests.swift
//  TestToDoTests
//
//  Created by Daniil Kim on 25.11.2024.
//

import XCTest
import CoreData
@testable import TestToDo

class NewTaskCreationTests: XCTestCase {
    var newTaskViewModel: NewTaskViewModel!
    var mockContext: NSManagedObjectContext!
    var persistenceController: PersistenceController!
    var taskListViewModel: TaskListViewModel!
    
    override func setUp() {
        super.setUp()
        
        persistenceController = PersistenceController(inMemory: true)
        mockContext = persistenceController.container.viewContext
        
        newTaskViewModel = NewTaskViewModel(persistenceController: persistenceController)
        taskListViewModel = TaskListViewModel(apiViewModel: APIViewModel(), persistenceController: persistenceController)
        
        let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        do {
            let tasks = try mockContext.fetch(fetchRequest)
            for task in tasks {
                mockContext.delete(task)
            }
            try mockContext.save()
        } catch {
            XCTFail("Failed to clear mock context")
        }
    }
    
    func testSaveTask() {
        newTaskViewModel.title = "New Task"
        newTaskViewModel.description = "Task description"
        
        newTaskViewModel.saveTask(to: taskListViewModel)
        
        let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        do {
            let tasks = try mockContext.fetch(fetchRequest)
            XCTAssertEqual(tasks.count, 1)
            XCTAssertEqual(tasks.first?.name, "New Task")
        } catch {
            XCTFail("Failed to fetch tasks")
        }
    }
}
