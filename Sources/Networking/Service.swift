//
//  Service.swift
//  
//
//  Created by Piotrek on 18/06/2022.
//

import Foundation

public protocol Service {
    var baseURL: URL { get }
    var responseDecoder: any DataDecoder { get }
    var bodyEncoder: any DataEncoder { get }

    func authorize<R: Request>(_ request: R) -> R
}

public extension Service {
    var bodyEncoder: any DataEncoder { JSONEncoder() }
    var responseDecoder: any DataDecoder { JSONDecoder() }

    func authorize<R: Request>(_ request: R) -> R {
        request
    }
}
