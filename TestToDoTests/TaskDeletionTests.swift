//
//  TaskDeletionTests.swift
//  TestToDoTests
//
//  Created by Daniil Kim on 25.11.2024.
//

import XCTest
import CoreData
@testable import TestToDo

class TaskDeletionTests: XCTestCase {
    var taskListViewModel: TaskListViewModel!
    var mockContext: NSManagedObjectContext!
    var persistenceController: PersistenceController!
    
    override func setUp() {
        super.setUp()
        
        persistenceController = PersistenceController(inMemory: true)
        mockContext = persistenceController.container.viewContext
        
        let apiViewModel = APIViewModel()
        taskListViewModel = TaskListViewModel(apiViewModel: apiViewModel, persistenceController: persistenceController)

        let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        do {
            let tasks = try mockContext.fetch(fetchRequest)
            for task in tasks {
                mockContext.delete(task)
            }
            try mockContext.save()
        } catch {
            print("Failed to clear context: \(error)")
        }
    }
    
    func testDeleteTask() {
        let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()

        XCTAssertEqual((try? mockContext.fetch(fetchRequest).count), 0, "Context should be empty initially")

        let task = TaskItem(context: mockContext)
        task.name = "Task to Delete"
        try? mockContext.save()
        XCTAssertEqual((try? mockContext.fetch(fetchRequest).count), 1, "Task should be added successfully")

        let expectation = XCTestExpectation(description: "Task deletion should complete")
        
        DispatchQueue.global(qos: .background).async {
            self.taskListViewModel.deleteTask(task)
            
            DispatchQueue.main.async {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3.0)

        let tasksAfterDeletion = try? mockContext.fetch(fetchRequest)
        print("Tasks after deletion: \(tasksAfterDeletion?.count ?? -1)")
        XCTAssertEqual(tasksAfterDeletion?.count, 0, "Task should be deleted successfully")
    }
}
