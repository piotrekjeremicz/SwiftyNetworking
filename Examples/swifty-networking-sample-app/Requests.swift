//
//  Requests.swift
//  swifty-networking-sample-app
//
//  Created by Piotrek Jeremicz on 09/04/2023.
//

import Foundation
import Networking

struct AuthExampleRequest: Request {
    let service: Service

    let login: String
    let password: String

    var body: some Request {
        Get("auth", "login", from: service)
            .headers {
                X_Api_Key("secret_token")
            }
            .queryItems{
                Key("login", value: login)
                Key("password", value: password)
            }
            .responseBody(ExampleAuthResponseModel.self)
    }
}


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
            .authorize()
            .responseBody(ExampleResponseModel.self)
            .responseError(ExampleErrorModel.self)
    }
}
