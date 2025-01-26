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
        // Создаем контроллер для тестов с памятью
        persistenceController = PersistenceController(inMemory: true)

        // Создаем mock APIViewModel
        apiViewModel = APIViewModel()

        // Создаем TaskListViewModel
        taskListViewModel = TaskListViewModel(apiViewModel: apiViewModel, persistenceController: persistenceController)
    }

    override func tearDownWithError() throws {
        persistenceController = nil
        taskListViewModel = nil
        apiViewModel = nil
    }

    func testSearchTasksNoMatch() {
        // Добавляем задачи в CoreData
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

        // Убедимся, что задачи сохранены
        let fetchedTasks = persistenceController.fetchTasks()
        XCTAssertEqual(fetchedTasks.count, 2, "There should be two tasks saved in Core Data")

        // Выполняем поиск по несуществующему слову "swim"
        taskListViewModel.searchText = "swim"
        taskListViewModel.filterTasks()

        // Принудительно обновляем filteredTasks
        taskListViewModel.objectWillChange.send()

        // Проверяем, что не найдено ни одной задачи
        XCTAssertEqual(taskListViewModel.filteredTasks.count, 0, "Filtered tasks count should be zero when there is no match")
    }
}
