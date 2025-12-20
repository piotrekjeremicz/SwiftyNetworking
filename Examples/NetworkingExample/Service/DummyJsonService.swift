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

    var beforeEachRequest: RequestInterceptorClosure? = { configuration in
        print("before each request: \(configuration.debugDescription)")
    }

    var afterEachResponse: ResponseInterceptorClosure? = { response, request in
        print("after each response from request: \(request.debugDescription)")
        return response
    }
}
