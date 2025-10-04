//
//  Request.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 19.09.2025.
//

import Foundation

@attached(member, names: named(ResponseBody), named(ResponseError))
@attached(extension, conformances: Request)
public macro Request() = #externalMacro(module: "NetworkingMacros", type: "RequestMacro")

public protocol Request: Sendable {
    associatedtype Body: Request
    associatedtype ResponseBody: Codable & Sendable = Body.ResponseBody
    associatedtype ResponseError: Codable & Sendable = Body.ResponseError
    
    var id: UUID { get }
    var body: Body { get }
    var configuration: ConfigurationValues? { get set }
    
    func makeRequest() -> ConfigurationValues
}

public extension Request {
    var id: UUID {
        configuration?.id ?? makeRequest().id
    }
    
    var configuration: ConfigurationValues? {
        get { nil }
        set {     }
    }
    
    var debugDescription: String {
        "\(type(of: Self.self))<B: \(type(of: ResponseBody.self)), E: \(type(of: ResponseError.self))>"
    }
}

public extension Request {
    func makeRequest() -> ConfigurationValues {
        if Self.self is EmptyRequest.Type {
            return .init()
        } else if let configuration {
            return configuration
        } else {
            return body.makeRequest()
        }
    }
}
