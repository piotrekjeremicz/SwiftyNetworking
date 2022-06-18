//
//  Requests.swift
//  
//
//  Created by Piotrek on 18/06/2022.
//

import Combine
import Foundation

struct EmptyRequest: Request {
    var content: Content? = nil
}

struct Get: Request {
    var content: Content?
    
    init(_ path: String, from service: Service, bodyEncoder: any TopLevelEncoder = JSONEncoder(), responseDecoder: any TopLevelDecoder = JSONDecoder()) {
        content = Content(
            path: path,
            service: service,
            method: .get,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}

struct Post: Request {
    var content: Content?
    
    init(_ path: String, from service: Service, bodyEncoder: any TopLevelEncoder = JSONEncoder(), responseDecoder: any TopLevelDecoder = JSONDecoder()) {
        content = Content(
            path: path,
            service: service,
            method: .post,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}

struct Put: Request {
    var content: Content?
    
    init(_ path: String, from service: Service, bodyEncoder: any TopLevelEncoder = JSONEncoder(), responseDecoder: any TopLevelDecoder = JSONDecoder()) {
        content = Content(
            path: path,
            service: service,
            method: .put,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}

struct Path: Request {
    var content: Content?
    
    init(_ path: String, from service: Service, bodyEncoder: any TopLevelEncoder = JSONEncoder(), responseDecoder: any TopLevelDecoder = JSONDecoder()) {
        content = Content(
            path: path,
            service: service,
            method: .patch,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}

struct Delete: Request {
    var content: Content?
    
    init(_ path: String, from service: Service, bodyEncoder: any TopLevelEncoder = JSONEncoder(), responseDecoder: any TopLevelDecoder = JSONDecoder()) {
        content = Content(
            path: path,
            service: service,
            method: .delete,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}
