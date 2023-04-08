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

let requestBody = ExampleRequestBodyModel(id: .init(), count: 4)

struct GetExampleRequest: Request {
    var body: some Request {
        Get("foo", "bar", from: service)
            .body(requestBody)
            .headers {
                X_Api_Key("secret_token")
            }
            .queryItems {
                Key("type", value: "numbers")
            }
            .response(ExampleResponseModel.self)
            .error(ExampleErrorModel.self)
    }
}

let getRequest = GetExampleRequest()
