//
//  Service.swift
//  
//
//  Created by Piotrek on 18/06/2022.
//

import Foundation

public protocol Service {
    var baseURL: URL { get }
    
    var requestBodyEncoder: any DataEncoder { get }

    var responseBodyDecoder: any DataDecoder { get }
    var responseBodyEncoder: any DataEncoder { get }

    func authorize<R: Request>(_ request: R) -> R
    
    var authorizationProvider: AuthorizationProvider? { get }
}

public extension Service {
    var requestBodyEncoder: any DataEncoder { JSONEncoder() }
    
    var responseBodyDecoder: any DataDecoder { JSONDecoder() }
    var responseBodyEncoder: any DataEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        return encoder
    }

    func authorize<R: Request>(_ request: R) -> R {
        request
    }
    
    var authorizationProvider: AuthorizationProvider? { nil }
}
