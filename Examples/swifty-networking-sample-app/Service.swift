//
//  main.swift
//  swifty-networking-sample-app
//
//  Created by Piotrek Jeremicz on 01/04/2023.
//

import Foundation
import Networking

struct BackendService: Service {
    var baseURL: URL { return URL(string: "https://example.com")! }
}

struct BackendExtentedService: Service {
    var baseURL: URL { return URL(string: "https://example.com")! }
    
    var requestBodyEncoder: DataEncoder { JSONEncoder() }
    var responseBodyDecoder: DataDecoder { JSONDecoder() }
    
    func authorize<R>(_ request: R) -> R where R : Old_Request {
        request
    }
}
