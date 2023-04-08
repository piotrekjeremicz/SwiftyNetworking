//
//  DeleteRequest.swift
//  
//
//  Created by Piotrek Jeremicz on 08/04/2023.
//

import Foundation

public struct Delete<ResponseBody: Codable, ResponseError: Codable>: HttpRequest {
    public var configuration: Configuration?

    public init(configuration: Configuration?) {
        self.configuration = configuration
    }
}

public extension Delete where ResponseBody == Empty, ResponseError == Empty {
    init(_ path: String..., from service: Service, bodyEncoder: (any DataEncoder)? = nil) {
        self.configuration = Configuration(path: path, service: service, method: .delete, bodyEncoder: bodyEncoder)
    }
}

public extension Delete {
    func error<E: Codable>(_ type: E.Type) -> Delete<ResponseBody, E> {
        Delete<ResponseBody, E>(configuration: self.configuration)
    }

    func response<R: Codable>(_ type: R.Type) -> Delete<R, ResponseError> {
        Delete<R, ResponseError>(configuration: self.configuration)
    }
}
