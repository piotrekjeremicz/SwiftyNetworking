//
//  GetToDosRequest.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 12.10.2025.
//

import Networking

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

func getToDosRequest(_ session: Session) async {
    let getToDosRequest = GetToDosRequest()
    await session.send(getToDosRequest)
}
