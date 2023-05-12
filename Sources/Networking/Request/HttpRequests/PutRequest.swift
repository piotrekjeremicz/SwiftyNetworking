//
//  PutRequest.swift
//  
//
//  Created by Piotrek Jeremicz on 08/04/2023.
//

import Foundation

public struct Put<ResponseBody: Codable, ResponseError: Codable>: HttpRequest {
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

public extension Put where ResponseBody == Empty, ResponseError == Empty {
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
            method: .put,
            requestBodyEncoder: requestBodyEncoder ?? service.requestBodyEncoder,
            responseBodyDecoder: responseBodyDecoder ?? service.responseBodyDecoder,
            responseBodyEncoder: responseBodyEncoder ?? service.responseBodyEncoder
        )
    }
}

public extension Put {
    func responseError<E: Codable>(_ type: E.Type) -> Put<ResponseBody, E> {
        Put<ResponseBody, E>(configuration: self.configuration)
    }

    func responseBody<R: Codable>(_ type: R.Type) -> Put<R, ResponseError> {
        Put<R, ResponseError>(configuration: self.configuration)
    }
}
