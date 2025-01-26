//
//  TestToDoApp.swift
//  TestToDo
//
//  Created by Daniil Kim on 17.11.2024.
//

import SwiftUI

@main
struct TestToDoApp: App {
    let persistenceController = PersistenceController()

    var body: some Scene {
        WindowGroup {
            TaskListView(viewModel: TaskListViewModel(apiViewModel: APIViewModel(), persistenceController: persistenceController), persistenceController: persistenceController)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.dark)
        }
    }
}
