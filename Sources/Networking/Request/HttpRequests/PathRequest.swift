//
//  PathRequest.swift
//  
//
//  Created by Piotrek Jeremicz on 08/04/2023.
//

import Foundation

public struct Path<ResponseBody: Codable, ResponseError: Codable>: HttpRequest {
    public var configuration: Configuration?

    public init(configuration: Configuration?) {
        self.configuration = configuration
    }
}

public extension Path where ResponseBody == Empty, ResponseError == Empty {
    init(_ path: String..., from service: Service, bodyEncoder: (any DataEncoder)? = nil) {
        self.configuration = Configuration(path: path, service: service, method: .patch, bodyEncoder: bodyEncoder)
    }
}

public extension Path {
    func error<E: Codable>(_ type: E.Type) -> Path<ResponseBody, E> {
        Path<ResponseBody, E>(configuration: self.configuration)
    }

    func response<R: Codable>(_ type: R.Type) -> Path<R, ResponseError> {
        Path<R, ResponseError>(configuration: self.configuration)
    }
}
