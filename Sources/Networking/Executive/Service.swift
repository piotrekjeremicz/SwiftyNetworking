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
}

public extension Service {
    var requestBodyEncoder: any DataEncoder { JSONEncoder() }
    
    var responseBodyDecoder: any DataDecoder { JSONDecoder() }
    var responseBodyEncoder: any DataEncoder { JSONEncoder() }

    func authorize<R: Request>(_ request: R) -> R {
        request
    }
}