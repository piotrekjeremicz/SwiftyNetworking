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
    
    typealias ResponseBody = Empty
    typealias ResponseError = Empty
    
    var body: some Request {
        Get("getArticles", from: service)
            .headers {
                Key("key", value: "value")
            }
            .queryItems {
                Key("index", value: "1")
            }
            .body(
                MockBody(filter: "all")
            )
            .authorized()
    }
}
