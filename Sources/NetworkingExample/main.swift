//
//  main.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 20.09.2025.
//

import Networking
import OSLog

// MARK: - Networking Configuration
let session = Session()

struct DummyJsonService: Service {
    let baseURL: String = "https://dummyjson.com"
    let logger: Logger? = Logger()
}

// MARK: - GET ToDos Request
@Request
struct GetToDosRequest {
    var body: some Request {
        Get("todos", from: DummyJsonService())
            .queryItems {
                Key("limit", value: 5)
            }
            .responseBody(Model.self)
    }
    
    nonisolated struct Model: Codable {
        let todos: [ToDo]
        let tota: Int
        let skip: Int
        let limit: Int
    }
}

let getToDosRequest = GetToDosRequest()
let todos = try? await session.trySend(getToDosRequest)

// MARK: - POST Add ToDo Request
@Request
struct AddToDoRequest {
    let todo: ToDo.New
    
    var body: some Request {
        Post("todos", "add", from: DummyJsonService())
            .body(.json, encodable: todo)
            .responseBody(ToDo.self)
    }
}

let newToDo = ToDo.new(todo: "Say Hello, World!", completed: false, userId: 5)
let addToDoRequest = AddToDoRequest(todo: newToDo)
let addedToDo = try? await session.trySend(addToDoRequest)

// MARK: - POST Login Request
@Request
struct LoginRequest {
    let username: String
    let password: String
    
    var body: some Request {
        Post("auth", "login", from: DummyJsonService())
            .body(.json) {
                Key("username", value: username)
                Key("password", value: password)
                Key("expiresInMins", value: 30)
            }
            .responseBody(AuthorizedUser.self)
    }
}

let loginRequest = LoginRequest(username: "emilys", password: "emilyspass")
let loginResponse = try? await session.trySend(loginRequest)

@Request
struct AuthRequest {
    var body: some Request {
        Get("auth", "me", from: DummyJsonService())
            .authorize()
    }
}
