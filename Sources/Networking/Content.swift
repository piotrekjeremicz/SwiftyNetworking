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
    public var headers: [String: String]?
    public var queryItems: [URLQueryItem]?
    
    public var bodyEncoder: any TopLevelEncoder
    public var responseDecoder: any TopLevelDecoder
}

