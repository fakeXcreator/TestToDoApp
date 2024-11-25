//
//  TasksSearchingTests.swift
//  TestToDoTests
//
//  Created by Daniil Kim on 25.11.2024.
//

import XCTest
@testable import TestToDo

class TasksSearchingTests: XCTestCase {
    var taskListViewModel: TaskListViewModel!
    
    override func setUp() {
        super.setUp()
        let apiViewModel = APIViewModel()
        taskListViewModel = TaskListViewModel(apiViewModel: apiViewModel)
    }
    
    func testFiltering() {
        let task1 = TaskItem(context: PersistenceController.shared.container.viewContext)
        task1.name = "Task 1"
        
        let task2 = TaskItem(context: PersistenceController.shared.container.viewContext)
        task2.name = "Task 2"
        
        let tasks = [task1, task2]
        
        let filtered = tasks.filter { $0.name?.localizedCaseInsensitiveContains("Task 1") == true }
        
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.name, "Task 1")
    }
}
