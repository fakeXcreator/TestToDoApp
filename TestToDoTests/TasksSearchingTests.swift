//
//  TasksSearchingTests.swift
//  TestToDoTests
//
//  Created by Daniil Kim on 25.11.2024.
//

import XCTest
import SwiftUI
@testable import TestToDo

class TaskSearchingTests: XCTestCase {

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

    func testSearchTasksNoMatch() {
        let task1 = TaskItem(context: persistenceController.container.viewContext)
        task1.id = 1
        task1.name = "Buy milk"
        task1.desc = "Description for Buy milk"
        task1.date = Date()

        let task2 = TaskItem(context: persistenceController.container.viewContext)
        task2.id = 2
        task2.name = "Go for a run"
        task2.desc = "Description for Go for a run"
        task2.date = Date()

        persistenceController.saveContext()

        let fetchedTasks = persistenceController.fetchTasks()
        XCTAssertEqual(fetchedTasks.count, 2, "There should be two tasks saved in Core Data")

        taskListViewModel.searchText = "swim"
        taskListViewModel.filterTasks()

        taskListViewModel.objectWillChange.send()

        XCTAssertEqual(taskListViewModel.filteredTasks.count, 0, "Filtered tasks count should be zero when there is no match")
    }
}
