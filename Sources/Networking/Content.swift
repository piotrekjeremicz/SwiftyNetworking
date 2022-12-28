//
//  Content.swift
//  
//
//  Created by Piotrek on 18/06/2022.
//

import Combine
import Foundation

public struct Content {
    public var responseType: Decodable.Type = Empty.self
    public var errorType: Decodable.Type = Empty.self
    
    public var path: String
    public var service: Service
    public var method: Method
    
    public var body: (any Encodable)?
    public var headers: [any KeyValueProvider]?
    public var queryItems: [any KeyValueProvider]?
    
    public var bodyEncoder: any DataEncoder
    public var responseDecoder: any DataDecoder

    public init(
        responseType: Decodable.Type = Empty.self,
        errorType: Decodable.Type = Empty.self,
        path: [String],
        service: Service,
        method: Method,
        body: (Encodable)? = nil,
        headers: [any KeyValueProvider]? = nil,
        queryItems: [any KeyValueProvider]? = nil,
        bodyEncoder: DataEncoder,
        responseDecoder: DataDecoder
    ) {
        self.responseType = responseType
        self.errorType = errorType
        self.path = path.joined(separator: "/")
        self.service = service
        self.method = method
        self.body = body
        self.headers = headers
        self.queryItems = queryItems
        self.bodyEncoder = bodyEncoder
        self.responseDecoder = responseDecoder
    }
}
