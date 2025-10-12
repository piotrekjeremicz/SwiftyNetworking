//
//  ResponseBuilder.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 10.10.2025.
//

import Foundation

struct ResponseBuilder {
    static func build<R>(_ result: (data: Data, response: URLResponse), from configuration: ConfigurationValues, request: R) async throws -> Response<R.ResponseBody> where R: Request {
        guard let httpResponse = result.response as? HTTPURLResponse
        else { throw ResponseError<Never>.unsupportedResponseType }
        
        if (200..<400).contains(httpResponse.statusCode) {
            let responseBody = try Response<R.ResponseBody>(result, from: configuration)
            return try await Self.resolve(responseBody, from: configuration, request: request)
        } else {
            let responseError = try Response<R.ResponseError>(result, from: configuration)
            let resolvedResponse = try await Self.resolve(responseError, from: configuration, request: request)
            
            throw ResponseError.serverError(resolvedResponse)
        }
    }
}

private extension ResponseBuilder {
    static func resolve<C, R>(_ response: Response<C>, from configuration: ConfigurationValues, request: R) async throws -> Response<C> where C: Codable, R: Request {
        var anyResponse = response.eraseToAnyCodable
        let interceptors = configuration.responseInterceptors
        
        for interceptor in interceptors {
            anyResponse = try await interceptor(anyResponse, request)
        }
        guard let typedResponse = anyResponse.as(C.self)
        else { throw ResponseError<Never>.interceptedResponseBodyTypeMismatch }
        
        return typedResponse
    }
}
