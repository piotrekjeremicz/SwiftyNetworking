//
//  MethodRequest.swift
//  
//
//  Created by Piotrek Jeremicz on 02/04/2023.
//

import Foundation

protocol MethodRequest: Request { }

public struct Get: MethodRequest {
    public var configuration: Configuration?

    public init(
        _ path: String...,
        from service: Service,
        bodyEncoder: (any DataEncoder)? = nil
    ) {
        self.configuration = Configuration(path: path, service: service, method: .get, bodyEncoder: bodyEncoder)
    }
}
