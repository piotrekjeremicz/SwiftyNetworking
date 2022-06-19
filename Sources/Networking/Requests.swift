//
//  Requests.swift
//  
//
//  Created by Piotrek on 18/06/2022.
//

import Combine
import Foundation

public struct EmptyRequest: Request {
    public typealias Response = Empty
    public typealias ResponseError = Empty
    
    public var content: Content? = nil
}

public struct Get: Request {
    public typealias Response = Empty
    public typealias ResponseError = Empty
    
    public var content: Content?
    
    public init(_ path: String, from service: Service, bodyEncoder: any TopLevelEncoder = JSONEncoder(), responseDecoder: any TopLevelDecoder = JSONDecoder()) {
        content = Content(
            path: path,
            service: service,
            method: .get,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}

public struct Post: Request {
    public typealias Response = Empty
    public typealias ResponseError = Empty
    
    public var content: Content?
    
    public init(_ path: String, from service: Service, bodyEncoder: any TopLevelEncoder = JSONEncoder(), responseDecoder: any TopLevelDecoder = JSONDecoder()) {
        content = Content(
            path: path,
            service: service,
            method: .post,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}

public struct Put: Request {
    public typealias Response = Empty
    public typealias ResponseError = Empty
    
    public var content: Content?
    
    public init(_ path: String, from service: Service, bodyEncoder: any TopLevelEncoder = JSONEncoder(), responseDecoder: any TopLevelDecoder = JSONDecoder()) {
        content = Content(
            path: path,
            service: service,
            method: .put,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}

public struct Path: Request {
    public typealias Response = Empty
    public typealias ResponseError = Empty
    
    public var content: Content?
    
    public init(_ path: String, from service: Service, bodyEncoder: any TopLevelEncoder = JSONEncoder(), responseDecoder: any TopLevelDecoder = JSONDecoder()) {
        content = Content(
            path: path,
            service: service,
            method: .patch,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}

public struct Delete: Request {
    public typealias Response = Empty
    public typealias ResponseError = Empty
    
    public var content: Content?
    
    public init(_ path: String, from service: Service, bodyEncoder: any TopLevelEncoder = JSONEncoder(), responseDecoder: any TopLevelDecoder = JSONDecoder()) {
        content = Content(
            path: path,
            service: service,
            method: .delete,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}
