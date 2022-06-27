//
//  Requests.swift
//  
//
//  Created by Piotrek on 18/06/2022.
//

import Combine
import Foundation

protocol GenericRequest: Request { }

public struct EmptyRequest: GenericRequest {
    public typealias Response = Empty
    public typealias ResponseError = Empty
    
    public var content: Content? = nil
}

public struct Get: GenericRequest {
    public typealias Response = Empty
    public typealias ResponseError = Empty
    
    public var content: Content?
    
    public init(_ path: String, from service: Service, bodyEncoder: any DataEncoder = JSONEncoder(), responseDecoder: any DataDecoder = JSONDecoder()) {
        content = Content(
            path: path,
            service: service,
            method: .get,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}

public struct Post: GenericRequest {
    public typealias Response = Empty
    public typealias ResponseError = Empty
    
    public var content: Content?
    
    public init(_ path: String, from service: Service, bodyEncoder: any DataEncoder = JSONEncoder(), responseDecoder: any DataDecoder = JSONDecoder()) {
        content = Content(
            path: path,
            service: service,
            method: .post,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}

public struct Put: GenericRequest {
    public typealias Response = Empty
    public typealias ResponseError = Empty
    
    public var content: Content?
    
    public init(_ path: String, from service: Service, bodyEncoder: any DataEncoder = JSONEncoder(), responseDecoder: any DataDecoder = JSONDecoder()) {
        content = Content(
            path: path,
            service: service,
            method: .put,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}

public struct Path: GenericRequest {
    public typealias Response = Empty
    public typealias ResponseError = Empty
    
    public var content: Content?
    
    public init(_ path: String, from service: Service, bodyEncoder: any DataEncoder = JSONEncoder(), responseDecoder: any DataDecoder = JSONDecoder()) {
        content = Content(
            path: path,
            service: service,
            method: .patch,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}

public struct Delete: GenericRequest {
    public typealias Response = Empty
    public typealias ResponseError = Empty
    
    public var content: Content?
    
    public init(_ path: String, from service: Service, bodyEncoder: any DataEncoder = JSONEncoder(), responseDecoder: any DataDecoder = JSONDecoder()) {
        content = Content(
            path: path,
            service: service,
            method: .delete,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}
