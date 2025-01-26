//
//  TasksUploadingTests.swift
//  TestToDoTests
//
//  Created by Daniil Kim on 25.11.2024.
//

import XCTest
import CoreData
@testable import TestToDo

class TasksUploadingTests: XCTestCase {
    var taskListViewModel: TaskListViewModel!
    var apiViewModel: APIViewModel!
    var persistenceController: PersistenceController!
    var mockContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        apiViewModel = APIViewModel()
        persistenceController = PersistenceController() // Инициализация PersistenceController
        taskListViewModel = TaskListViewModel(apiViewModel: apiViewModel, persistenceController: persistenceController)
        
        mockContext = persistenceController.container.viewContext

        // Очистка Core Data перед тестами
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TaskItem.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try mockContext.execute(deleteRequest)
        } catch {
            XCTFail("Failed to clear Core Data")
        }
    }
    
    func testSaveTasksToCoreData() {
        let expectation = self.expectation(description: "Tasks saved")

        let apiTasks = [
            APIModel(id: 1, todo: "API Task 1", completed: false, userId: 123),
            APIModel(id: 2, todo: "API Task 2", completed: true, userId: 456)
        ]

        taskListViewModel.saveTasksToCoreData(from: apiTasks)
        
        // Wait for a short delay to ensure the tasks are saved
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)

        let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        do {
            let tasks = try mockContext.fetch(fetchRequest)
            XCTAssertEqual(tasks.count, 2, "The number of tasks saved should be 2")
            XCTAssertEqual(tasks.first?.name, "API Task 1", "First task name should match API Task 1")
            XCTAssertEqual(tasks.last?.name, "API Task 2", "Last task name should match API Task 2")
        } catch {
            XCTFail("Failed to fetch tasks after saving from API")
        }
    }
}
