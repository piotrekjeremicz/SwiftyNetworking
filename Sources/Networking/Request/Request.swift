//
//  Request.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 19.09.2025.
//

public protocol Request {
    associatedtype Body: Request
    
    var body: Body { get }
}
