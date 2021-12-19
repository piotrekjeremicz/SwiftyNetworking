//
//  Request.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 19/12/2021.
//

import Foundation

public enum RquestMethod: String {
    case get
    case put
    case post
    case patch
    case delete
}

public protocol Request {
    
    associatedtype Body: Codable
    associatedtype Response: Codable
    associatedtype ResponseError: Codable
        
    var path: String { get }
    var service: Service { get }
    var method: RquestMethod { get }
    
    var body: Body? { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    
    var bodyEncoder: JSONEncoder { get }
    var responseDecoder: AnyDataDecoder { get }
    
    func urlRequest() -> URLRequest
}

extension Request {
    var body: Body? { nil }
    var headers: [String: String]? { nil }
    var queryItems: [URLQueryItem]? { nil }

    var bodyEncoder: JSONEncoder { JSONEncoder() }
    var responseDecoder: JSONDecoder { JSONDecoder() }
    
    func urlRequest() -> URLRequest? {
        guard var urlComponents = URLComponents(url: service.baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        else { return nil }
        
        if let queryItems = queryItems { urlComponents.queryItems = queryItems }
        
        guard let url = urlComponents.url
        else { return nil}
        
        var urlRequest = URLRequest(url: url)
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

