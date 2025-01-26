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
        
        // Создаем новый PersistenceController для тестов
        persistenceController = PersistenceController(inMemory: true)
        mockContext = persistenceController.container.viewContext
        
        let apiViewModel = APIViewModel()
        taskListViewModel = TaskListViewModel(apiViewModel: apiViewModel, persistenceController: persistenceController)

        // Очищаем mockContext перед каждым тестом
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

        // Проверяем, что контекст изначально пуст
        XCTAssertEqual((try? mockContext.fetch(fetchRequest).count), 0, "Context should be empty initially")

        // Создаем задачу для удаления
        let task = TaskItem(context: mockContext)
        task.name = "Task to Delete"
        try? mockContext.save()
        XCTAssertEqual((try? mockContext.fetch(fetchRequest).count), 1, "Task should be added successfully")

        // Ожидаем завершения удаления
        let expectation = XCTestExpectation(description: "Task deletion should complete")
        
        // Perform deletion in background and fulfill expectation when done
        DispatchQueue.global(qos: .background).async {
            self.taskListViewModel.deleteTask(task)
            
            DispatchQueue.main.async {
                expectation.fulfill()
            }
        }
        
        // Wait for the deletion to complete
        wait(for: [expectation], timeout: 3.0)

        // Проверяем, что задача была удалена
        let tasksAfterDeletion = try? mockContext.fetch(fetchRequest)
        print("Tasks after deletion: \(tasksAfterDeletion?.count ?? -1)")
        XCTAssertEqual(tasksAfterDeletion?.count, 0, "Task should be deleted successfully")
    }
}
