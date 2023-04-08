//
//  GetRequest.swift
//  
//
//  Created by Piotrek Jeremicz on 08/04/2023.
//

import Foundation

public struct Get<ResponseBody: Codable, ResponseError: Codable>: HttpRequest {
    public var configuration: Configuration?

    public init(configuration: Configuration?) {
        self.configuration = configuration
    }
}

public extension Get where ResponseBody == Empty, ResponseError == Empty {
    init(_ path: String..., from service: Service, bodyEncoder: (any DataEncoder)? = nil, responseDecoder: (any DataDecoder)? = nil) {
        let bodyEncoder = bodyEncoder == nil ? service.requestBodyEncoder : bodyEncoder!
        let responseDecoder = responseDecoder == nil ? service.responseBodyDecoder : responseDecoder!

        self.configuration = Configuration(
            path: path,
            service: service,
            method: .delete,
            requestBodyEncoder: bodyEncoder,
            responseBodyDecoder: responseDecoder
        )
    }
}

public extension Get {
    func error<E: Codable>(_ type: E.Type) -> Get<ResponseBody, E> {
        Get<ResponseBody, E>(configuration: self.configuration)
    }

    func response<R: Codable>(_ type: R.Type) -> Get<R, ResponseError> {
        Get<R, ResponseError>(configuration: self.configuration)
    }
}
