//
//  Request.swift
//  
//
//  Created by Piotrek on 18/06/2022.
//

import Foundation
import Combine

enum Method: String {
    case get
    case put
    case post
    case patch
    case delete
}

protocol Request {
    associatedtype Body: Request
    
    var request: Body { get }
    var content: Content? { get set }
    
    func urlRequest() throws -> URLRequest
}

extension Request {
    var request: some Request { EmptyRequest() }
    var content: Content? {
        get { nil }
        set {     }
    }
    
    func urlRequest() throws -> URLRequest {
        guard let content = content
        else { throw RequestError.requestContentIsNotSet }
        
        guard var urlComponents = URLComponents(url: content.service.baseURL.appendingPathComponent(content.path), resolvingAgainstBaseURL: false)
        else { throw RequestError.resolvingUrlComponentsFailed }
        
        urlComponents.queryItems = content.queryItems
        
        guard let url = urlComponents.url
        else { throw RequestError.resolvingUrlComponentsFailed }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = content.method.rawValue
        content.headers?.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }
        
        if let body = content.body {
            let data = try? content.bodyEncoder.encode(body) as? Data
            urlRequest.httpBody = data
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }
    
    @inlinable func body(_ data: any Encodable) -> some Request {
        var request = self
        request.content?.body = data
        
        return request
    }
    
    @inlinable func headers(_ array: [String: String]) -> some Request {
        var request = self
        request.content?.headers = array
        
        return request
    }
    
    @inlinable func queryItems(_ items: [URLQueryItem]) -> some Request {
        var request = self
        request.content?.queryItems = items
        
        return request
    }
}


