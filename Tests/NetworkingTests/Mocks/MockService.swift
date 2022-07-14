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
}
