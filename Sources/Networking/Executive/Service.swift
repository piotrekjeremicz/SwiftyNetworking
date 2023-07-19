//
//  Service.swift
//  
//
//  Created by Piotrek on 18/06/2022.
//

import OSLog
import Foundation

fileprivate let networkingLogger = Logger(subsystem: "com.jeremicz.networking", category: "networking")

public protocol Service {
    var baseURL: URL { get }
    var logger: Logger { get }
    
    var requestBodyEncoder: any DataEncoder { get }

    var responseBodyDecoder: any DataDecoder { get }
    var responseBodyEncoder: any DataEncoder { get }

    func beforeEach<R: Request>(_ request: R) -> R
    func afterEach<B: Codable>(_ response: Response<B>) -> Response<B>
    
    var authorizationProvider: AuthorizationProvider? { get }
    
    
}

public extension Service {
    var logger: Logger { networkingLogger }
    
    var requestBodyEncoder: any DataEncoder { JSONEncoder() }
    
    var responseBodyDecoder: any DataDecoder { JSONDecoder() }
    var responseBodyEncoder: any DataEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        return encoder
    }

    func beforeEach<R: Request>(_ request: R) -> R {
        request
    }

    func afterEach<B: Codable>(_ response: Response<B>) -> Response<B> {
        response
    }
    
    var authorizationProvider: AuthorizationProvider? { nil }
}
