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



let getRequest = GetExampleRequest()
