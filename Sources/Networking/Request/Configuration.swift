//
//  Configuration.swift
//  
//
//  Created by Piotrek Jeremicz on 02/04/2023.
//

import Foundation

public struct Configuration {
    public var path: String
    public var service: Service
    public var method: Method
    
    public var body: (any Codable)?
    public var headers: [any KeyValueProvider]?
    public var queryItems: [any KeyValueProvider]?
    
    public var bodyEncoder: (any DataEncoder)?

    private let responseBuilder: Builder

    internal init(
        path: [String],
        service: Service,
        method: Method,
        body: (any Codable)? = nil,
        headers: [any KeyValueProvider]? = nil,
        queryItems: [any KeyValueProvider]? = nil,
        bodyEncoder: DataEncoder?
    ) {
        self.path = path.joined(separator: "/")
        self.service = service
        self.method = method

        self.body = body
        self.headers = headers
        self.queryItems = queryItems

        self.bodyEncoder = bodyEncoder

        self.responseBuilder = Builder()
    }
}

public struct Builder {

}
