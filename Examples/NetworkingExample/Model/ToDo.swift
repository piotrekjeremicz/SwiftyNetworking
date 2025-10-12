//
//  ToDo.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 11.10.2025.
//

import Foundation

nonisolated struct ToDo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
    
    static func new(todo: String, completed: Bool, userId: Int) -> ToDo.New {
        .init(todo: todo, completed: completed, userId: userId)
    }
}

nonisolated extension ToDo {
    struct New: Codable {
        let todo: String
        let completed: Bool
        let userId: Int
    }
}
