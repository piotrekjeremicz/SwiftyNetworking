//
//  Content.swift
//  
//
//  Created by Piotrek on 18/06/2022.
//

import Combine
import Foundation

struct Content {
    var path: String
    var service: Service
    var method: Method
    
    var body: (any Encodable)?
    var headers: [String: String]?
    var queryItems: [URLQueryItem]?
    
    var bodyEncoder: any TopLevelEncoder
    var responseDecoder: any TopLevelDecoder
}
