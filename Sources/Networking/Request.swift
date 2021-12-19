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
    
    var bodyEncoder: JSONEncoder { get }
    var responseDecoder: AnyDataDecoder { get }
    
    func urlRequest() -> URLRequest
}

public extension Request {
    typealias ResponseError = Empty
    
    var body: AnyCodable? { nil }
    var headers: [String: String]? { nil }
    var queryItems: [URLQueryItem]? { nil }

    var bodyEncoder: JSONEncoder { JSONEncoder() }
    var responseDecoder: JSONDecoder { JSONDecoder() }
    
    func urlRequest() -> URLRequest {
        var urlComponents = URLComponents(url: service.baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        if let queryItems = queryItems { urlComponents.queryItems = queryItems }
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = method.rawValue
        headers?.forEach { urlRequest.addValue($0, forHTTPHeaderField: $1) }
        
        if let body = body {
            let data = try? bodyEncoder.encode(body)
            urlRequest.httpBody = data
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }
}
