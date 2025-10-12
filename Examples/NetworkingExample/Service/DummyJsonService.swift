//
//  DummyJsonService.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 12.10.2025.
//

import Networking
import OSLog

struct DummyJsonService: Service {
    let baseURL: String = "https://dummyjson.com"
    let logger: Logger? = Logger()
    
    var authorizationProvider: (any AuthorizationProvider)? = DummyAuthorizationProvider()
}
