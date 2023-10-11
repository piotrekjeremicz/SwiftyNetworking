//
//  Requests.swift
//  swifty-networking-sample-app
//
//  Created by Piotrek Jeremicz on 09/04/2023.
//

import Foundation
import Networking

@Request
struct AuthExampleRequest {
    let service: Service

    let login: String
    let password: String

    var body: some Request {
        Get("auth", "login", from: service)
            .headers {
                X_Api_Key(value: "secret_token")
            }
            .queryItems{
                Key("login", value: login)
                Key("password", value: password)
            }
            .responseBody(ExampleAuthResponseModel.self)
    }
}

@Request
struct GetExampleRequest {
    var body: some Request {
        Post("foo", "bar", from: service)
            .headers {
                X_Api_Key(value: "secret_token")
            }
            .queryItems {
                Key("type", value: "numbers")
            }
            .authorize()
            .responseBody(ExampleResponseModel.self)
            .responseError(ExampleErrorModel.self)
            .mock { request in
                ExampleResponseModel(id: .init(), title: "self", description: "sef")
            }
    }
}
