//
//  PutRequest.swift
//  
//
//  Created by Piotrek Jeremicz on 08/04/2023.
//

import Foundation

public struct Put<ResponseBody: Codable, ResponseError: Codable>: HttpRequest {
    public var configuration: Configuration?

    public init(configuration: Configuration?) {
        self.configuration = configuration
    }
}

public extension Put where ResponseBody == Empty, ResponseError == Empty {
    init(_ path: String..., from service: Service, bodyEncoder: (any DataEncoder)? = nil) {
        self.configuration = Configuration(path: path, service: service, method: .put, bodyEncoder: bodyEncoder)
    }
}

public extension Put {
    func error<E: Codable>(_ type: E.Type) -> Put<ResponseBody, E> {
        Put<ResponseBody, E>(configuration: self.configuration)
    }

    func response<R: Codable>(_ type: R.Type) -> Put<R, ResponseError> {
        Put<R, ResponseError>(configuration: self.configuration)
    }
}
