//
//  Service.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 28.09.2025.
//

import Foundation
import OSLog

public protocol Service: Sendable {
    var baseURL: String { get }
    var logger: Logger? { get }
    
    var requestBodyEncoder: any TopLevelEncoder { get }
    var responseBodyDecoder: any TopLevelDecoder { get }
    
    var beforeEachRequest: RequestInterceptorClosure? { get }
    var afterEachResponse: ResponseInterceptorClosure? { get }
    
    var authorizationProvider: AuthorizationProvider? { get }
}

public extension Service {
    var logger: Logger? { nil }
}

public extension Service {
    var requestBodyEncoder: any TopLevelEncoder { JSONEncoder() }    
    var responseBodyDecoder: any TopLevelDecoder { JSONDecoder() }
    
    var beforeEachRequest: RequestInterceptorClosure? { nil }
    var afterEachResponse: ResponseInterceptorClosure? { nil }
    
    var authorizationProvider: AuthorizationProvider? { nil }
}
