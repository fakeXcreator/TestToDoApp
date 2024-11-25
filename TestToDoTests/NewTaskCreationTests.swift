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
    
    override func setUp() {
        super.setUp()
        mockContext = PersistenceController.shared.container.viewContext
        newTaskViewModel = NewTaskViewModel()
        
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
        
        print("Title: \(newTaskViewModel.title), Description: \(newTaskViewModel.description)")  
        
        let viewModel = TaskListViewModel(apiViewModel: APIViewModel())
        newTaskViewModel.saveTask(to: viewModel)
        
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

