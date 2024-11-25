//
//  APIViewModel.swift
//  TestToDo
//
//  Created by Daniil Kim on 19.11.2024.
//

import Foundation

struct Task: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

class APIViewModel {
    var tasksFromAPI: [Task] = []
    
    func fetchDataFromAPI() {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let jsonResponse = try JSONDecoder().decode([String: [Task]].self, from: data)
                self.tasksFromAPI = jsonResponse["todos"] ?? []
            } catch {
                print("Decoding error: \(error)")
            }
        }
        task.resume()
    }
}
