//
//  ResponseBuilder.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 10.10.2025.
//

import Foundation

struct ResponseBuilder {
    static func build<R>(_ result: (data: Data, response: URLResponse), from configuration: ConfigurationValues, request: R) throws -> Response<R.ResponseBody> where R: Request {
        guard let httpResponse = result.response as? HTTPURLResponse
        else { throw ResponseError<Never>.unsupportedResponseType }
        
        if (200..<400).contains(httpResponse.statusCode) {
            return try Response<R.ResponseBody>(result, from: configuration)
        } else {
            let responseError = try Response<R.ResponseError>(result, from: configuration)
            throw ResponseError.serverError(responseError)
        }
    }
}
