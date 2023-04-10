//
//  Mock.swift
//  
//
//  Created by Piotrek on 24/07/2022.
//

import Foundation

@resultBuilder
public struct CaseBuilder {
    public static func buildBlock(_ cases: Mock.Case...) -> [Mock.Case] {
        return cases
    }
}

public struct Mock {
    @CaseBuilder public let flow: (Mock.Request) -> [Mock.Case]
    
    public init(@CaseBuilder flow: @escaping (Mock.Request) -> [Mock.Case]) {
        self.flow = flow
    }
}

extension Mock {
    public struct Request {
        public let url: URL
        public let method: Method
        
        public let body: Data?
        public let headers: [any KeyValueProvider]?
        public let queryItems: [any KeyValueProvider]?
        
        init?(content: Content) {
            guard var urlComponents = URLComponents(url: content.service.baseURL.appendingPathComponent(content.path), resolvingAgainstBaseURL: false)
            else { return nil }
            
//            urlComponents.queryItems = content.queryItems
            
            guard let url = urlComponents.url
            else { return nil }
            
            self.url = url
            
            if let body = content.body {
                let data = try? content.bodyEncoder.encode(body)
                self.body = data
            } else {
                self.body = nil
            }
            
            self.method = content.method
            self.headers = content.headers
            self.queryItems = content.queryItems
        }
    }
    
    public enum Response {
        case success
        case error(statusCode: Int)
    }
    
    
    
    public struct Case {
        
        
        static func success(when: Bool, response: @escaping () -> (Mock.Response)) {
            
        }
    }
}
