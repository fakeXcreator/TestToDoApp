//
//  APIModel.swift
//  TestToDo
//
//  Created by Daniil Kim on 19.11.2024.
//

import Foundation

struct APIResponse: Codable {
    let todos: [APIModel]
    let total: Int
    let skip: Int
    let limit: Int
}

struct APIModel: Hashable, Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
