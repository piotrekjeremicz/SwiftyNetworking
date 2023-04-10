//
//  main.swift
//  swifty-networking-sample-app
//
//  Created by Piotrek Jeremicz on 02/04/2023.
//

import Foundation
import Networking

let session = Old_Session()
let service = BackendService()

let authRequest = AuthExampleRequest(service: service, login: "username", password: "secret")

let getRequest = GetExampleRequest()
