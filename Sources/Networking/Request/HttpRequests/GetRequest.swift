//
//  GetRequest.swift
//  
//
//  Created by Piotrek Jeremicz on 08/04/2023.
//

import Foundation

public struct Get<ResponseBody: Codable, ResponseError: Codable>: HttpRequest {
    public var id: UUID = .init()
    
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

public extension Get where ResponseBody == Empty, ResponseError == Empty {
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
            method: .get,
            requestBodyEncoder: requestBodyEncoder ?? service.requestBodyEncoder,
            responseBodyDecoder: responseBodyDecoder ?? service.responseBodyDecoder,
            responseBodyEncoder: responseBodyEncoder ?? service.responseBodyEncoder
        )
    }
}

public extension Get {
    @inlinable func responseError<E: Codable>(_ type: E.Type) -> Get<ResponseBody, E> {
        Get<ResponseBody, E>(configuration: self.configuration)
    }

    @inlinable func responseBody<R: Codable>(_ type: R.Type) -> Get<R, ResponseError> {
        Get<R, ResponseError>(configuration: self.configuration)
    }
    
    @inlinable func afterAutorization(_ completion: @escaping (_ response: ResponseBody, _ store: AuthorizationStore) -> Void) -> Self {
        return Get<ResponseBody, ResponseError>(configuration: self.configuration, afterAuthorization: completion)
    }
}
