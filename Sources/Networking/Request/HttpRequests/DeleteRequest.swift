//
//  DeleteRequest.swift
//  
//
//  Created by Piotrek Jeremicz on 08/04/2023.
//

import Foundation

public struct Delete<ResponseBody: Codable, ResponseError: Codable>: HttpRequest {
    public var configuration: Configuration?
    public var builder: ResponseBuilder<ResponseBody>
    
    public init(configuration: Configuration?) {
        self.configuration = configuration
        self.builder = ResponseBuilder<ResponseBody>()
    }
    
    public init(configuration: Configuration?, afterAuthorization: @escaping (_ response: ResponseBody, _ store: AuthorizationStore) -> Void) {
        self.configuration = configuration
        self.builder = ResponseBuilder(afterAuthorization: afterAuthorization)
    }
}

public extension Delete where ResponseBody == Empty, ResponseError == Empty {
    init(
        _ path: String...,
        from service: Service,
        requestBodyEncoder: (any DataEncoder)? = nil,
        responseBodyDecoder: (any DataDecoder)? = nil,
        responseBodyEncoder: (any DataEncoder)? = nil
    ) {
        self.builder = ResponseBuilder<ResponseBody>()
        self.configuration = Configuration(
            path: path,
            service: service,
            method: .delete,
            requestBodyEncoder: requestBodyEncoder ?? service.requestBodyEncoder,
            responseBodyDecoder: responseBodyDecoder ?? service.responseBodyDecoder,
            responseBodyEncoder: responseBodyEncoder ?? service.responseBodyEncoder
        )
    }
}

public extension Delete {
    @inlinable func responseError<E: Codable>(_ type: E.Type) -> Delete<ResponseBody, E> {
        Delete<ResponseBody, E>(configuration: self.configuration)
    }

    @inlinable func responseBody<R: Codable>(_ type: R.Type) -> Delete<R, ResponseError> {
        Delete<R, ResponseError>(configuration: self.configuration)
    }
    
    @inlinable func afterAutorization(_ completion: @escaping (_ response: ResponseBody, _ store: AuthorizationStore) -> Void) -> Self {
        return Delete<ResponseBody, ResponseError>(configuration: self.configuration, afterAuthorization: completion)
    }
}
