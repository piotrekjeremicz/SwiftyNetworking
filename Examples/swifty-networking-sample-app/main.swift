//
//  main.swift
//  swifty-networking-sample-app
//
//  Created by Piotrek Jeremicz on 02/04/2023.
//

import Foundation
import Networking

let session = Session()
let service = BackendService()

struct GetExampleRequest: Request {
    var body: some Request {
        Get("foo", "bar", from: service)
            .response(ExampleResponseModel.self)
            .error(ExampleErrorModel.self)
            .body("This is some text")
            .body {
                Key("foo", value: "bar")
            }
    }
}

let getRequest = GetExampleRequest()
