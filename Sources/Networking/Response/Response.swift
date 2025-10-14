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
    
    private init(body: Body, statusCode: Int, headers: [String: String]) {
        self.body = body
        self.statusCode = statusCode
        self.headers = headers
    }
}

extension Response {
    var eraseToAnyCodable: Response<AnyCodable> {
        Response<AnyCodable>.init(
            body: .init(body),
            statusCode: statusCode,
            headers: headers
        )
    }
}

extension Response where Body == AnyCodable {
    func `as`<B>(_ type: B.Type) -> Response<B>? where B: Codable {
        guard let typedBody = body.value as? B
        else { return nil }
        
        return Response<B>.init(
            body: typedBody,
            statusCode: statusCode,
            headers: headers
        )
    }
}
