//
//  main.swift
//  swifty-networking-sample-app
//
//  Created by Piotrek Jeremicz on 02/04/2023.
//

import Foundation
import Networking

let session = Session(debugLogging: true)
let service = BackendService()

let authRequest = AuthExampleRequest(service: service, login: "username", password: "secret")
let getRequest = GetExampleRequest(requestBody: .init(id: UUID(), count: 2))

Task {
    let (auth, error) = await session.send(request: getRequest)

    print(auth)
    print(error)
}

sleep(10)
