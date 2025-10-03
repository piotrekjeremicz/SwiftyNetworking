//
//  Request.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 19.09.2025.
//

@attached(member, names: named(ResponseBody), named(ResponseError))
@attached(extension, conformances: Request)
public macro Request() = #externalMacro(module: "NetworkingMacros", type: "RequestMacro")

public protocol Request {
    associatedtype Body: Request
    associatedtype ResponseBody: Codable = Body.ResponseBody
    associatedtype ResponseError: Codable = Body.ResponseError
    
    var body: Body { get }
    var configuration: ConfigurationValues? { get set }
    
    func makeRequest() -> ConfigurationValues
}

public extension Request {
    var configuration: ConfigurationValues? {
        get { nil }
        set {     }
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
