//
//  MockRequest.swift
//  
//
//  Created by Piotrek on 09/07/2022.
//

import Foundation
import Networking

struct MockRequest: Request {
    
    let service: Service
    
    typealias Response = Empty
    typealias ResponseError = Empty
    
    var request: some Request {
        Get("getArticles", from: service)
            .headers {
                Authorization("secret_token")
            }
            .queryItems {
                Key("index", value: "1")
            }
            .body(
                MockBody(filter: "all")
            )
    }
}
