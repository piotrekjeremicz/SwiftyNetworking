//
//  Request.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 19/12/2021.
//

import Foundation
import AnyCodable

public enum RquestMethod: String {
    case get
    case put
    case post
    case patch
    case delete
}

public protocol Request {
    associatedtype Response: Codable
    associatedtype ResponseError: Codable
    
    var path: String { get }
    var service: Service { get }
    var method: RquestMethod { get }
    
    var body: AnyCodable? { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    
    var bodyEncoder: AnyDataEncoder { get }
    var responseDecoder: AnyDataDecoder { get }
    
    func urlRequest() throws -> URLRequest
}

public extension Request {    
    var body: AnyCodable? { nil }
    var headers: [String: String]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    
    var bodyEncoder: AnyDataEncoder { JSONEncoder() }
    var responseDecoder: AnyDataDecoder { JSONDecoder() }
    
    func urlRequest() throws -> URLRequest {
        guard
            var urlComponents = URLComponents(url: service.baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        else { throw RequestError.resolvingUrlComponentsFailed }
        
        if let queryItems = queryItems { urlComponents.queryItems = queryItems }
        
        guard
            let url = urlComponents.url
        else { throw RequestError.resolvingUrlComponentsFailed }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        headers?.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }
        
        if let body = body {
            let data = try? bodyEncoder.encode(body)
            urlRequest.httpBody = data
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }
}
