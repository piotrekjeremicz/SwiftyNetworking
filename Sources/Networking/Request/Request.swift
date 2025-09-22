//
//  Request.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 19.09.2025.
//

public protocol Request {
    associatedtype Body: Request
    
    var body: Body { get }    
    var configuration: ConfigurationValues { get }
}

public extension Request {
    var configuration: ConfigurationValues { body.configuration }
}
