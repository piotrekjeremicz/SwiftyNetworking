//
//  PostRequest.swift
//  
//
//  Created by Piotrek Jeremicz on 08/04/2023.
//

import Foundation

public struct Post<ResponseBody: Codable, ResponseError: Codable>: HttpRequest {
    public var configuration: Configuration?

    public init(configuration: Configuration?) {
        self.configuration = configuration
    }
}

public extension Post where ResponseBody == Empty, ResponseError == Empty {
    init(
        _ path: String...,
        from service: Service,
        requestBodyEncoder: (any DataEncoder)? = nil,
        responseBodyDecoder: (any DataDecoder)? = nil,
        responseBodyEncoder: (any DataEncoder)? = nil
    ) {
        self.configuration = Configuration(
            path: path,
            service: service,
            method: .post,
            requestBodyEncoder: requestBodyEncoder ?? service.requestBodyEncoder,
            responseBodyDecoder: responseBodyDecoder ?? service.responseBodyDecoder,
            responseBodyEncoder: responseBodyEncoder ?? service.responseBodyEncoder
        )
    }
}

public extension Post {
    func responseError<E: Codable>(_ type: E.Type) -> Post<ResponseBody, E> {
        Post<ResponseBody, E>(configuration: self.configuration)
    }

    func responseBody<R: Codable>(_ type: R.Type) -> Post<R, ResponseError> {
        Post<R, ResponseError>(configuration: self.configuration)
    }
}