//
//  MockService.swift
//  
//
//  Created by Piotrek on 09/07/2022.
//

import Foundation
import Networking

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
}
