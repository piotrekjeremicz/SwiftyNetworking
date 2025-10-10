//
//  Response.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 10.10.2025.
//

import Foundation

public struct Response<Body>: Sendable where Body: Codable & Sendable {
    public let body: Body
    public let statusCode: Int
    public let headers: [String: String]
    
    init(_ result: (data: Data, response: URLResponse), from configuration: ConfigurationValues) throws {
        guard let httpResponse = result.response as? HTTPURLResponse
        else { throw ResponseError<Never>.unsupportedResponseType }
        
        statusCode = httpResponse.statusCode
        
        guard let decoder = configuration.service?.responseBodyDecoder
        else { throw ResponseError<Never>.missingService }
        
        body = try decoder.decode(Body.self, from: result.data)
        headers = httpResponse.allHeaderFields.reduce(into: [:]) { partialResult, item in
            partialResult[item.key.description] = "\(item.value)"
        }
    }
}
