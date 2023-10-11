//
//  main.swift
//  NetworkingExampleApp
//
//  Created by Piotrek Jeremicz on 02/04/2023.
//

import Foundation
import Networking

let session = Session(
    configuration: .init(
        logging: true,
        mock: .init(
            responseDelay: .seconds(2),
            resolveAs: .successfulResponse
        )
    )
)

let service = BackendService()

let authRequest = AuthExampleRequest(service: service, login: "username", password: "secret")
let getRequest = GetExampleRequest()

Task {
    let (body, error) = await session.send(request: getRequest)

    print(body)
    print(error)
}

sleep(10)
