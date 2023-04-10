//
//  MockService.swift
//  
//
//  Created by Piotrek on 09/07/2022.
//

import Foundation
import Networking

struct MockSimpleService: Service {
    var baseURL: URL { .init(string: "https://example.com")! }
}

struct MockService: Service {
    var baseURL: URL { .init(string: "https://example.com")! }
    
    var responseDecoder: DataDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.userInfo = [.init(rawValue: "test")!: "abcd"]

        return jsonDecoder
    }

    var bodyEncoder: DataEncoder {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.userInfo = [.init(rawValue: "test")!: "abcd"]

        return jsonEncoder
    }

    func authorize<R>(_ request: R) -> R where R : Old_Request {
        request.headers {
            Authorization("secret_token")
        }
    }
}
