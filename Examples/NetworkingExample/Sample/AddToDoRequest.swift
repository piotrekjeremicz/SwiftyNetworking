//
//  AddToDoRequest.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 12.10.2025.
//

import Networking

@Request
struct AddToDoRequest {
    let todo: ToDo.New
    
    var body: some Request {
        Post("todos", "add", from: DummyJsonService())
            .body(.json, encodable: todo)
            .responseBody(ToDo.self)
    }
}

func addToDoRequest(_ session: Session) async {
    let newToDo = ToDo.new(todo: "Say Hello, World!", completed: false, userId: 5)
    let addToDoRequest = AddToDoRequest(todo: newToDo)
    await session.send(addToDoRequest)
}
