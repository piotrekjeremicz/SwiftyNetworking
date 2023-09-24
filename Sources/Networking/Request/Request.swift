//
//  Request.swift
//  
//
//  Created by Piotrek on 18/06/2022.
//

import Foundation

@attached(member, names: named(ResponseBody), named(ResponseError))
@attached(extension, conformances: Request)
public macro Request() = #externalMacro(module: "NetworkingMacros", type: "RequestMacro")

public enum Method: String {
    case get
    case put
    case post
    case patch
    case delete
}

public protocol Request: CustomStringConvertible {
    associatedtype Body: Request
    associatedtype ResponseBody: Codable
    associatedtype ResponseError: Codable

    var id: UUID { get }
    var body: Body { get }
    var resolve: Self { get }
    
    var configuration: Configuration? { get set }
    var builder: ResponseBuilder<ResponseBody> { get set }

    func urlRequest() throws -> URLRequest
}

public extension Request {

    var id: UUID { UUID() }
    var body: some Request { EmptyRequest() }

    var resolve: Self {
        configuration?.service.beforeEach(self) ?? self
    }
    
    var configuration: Configuration? {
        get { nil }
        set {     }
    }
    
    var builder: ResponseBuilder<ResponseBody> {
        get { ResponseBuilder<ResponseBody>() }
        set {                                 }
    }

    func urlRequest() throws -> URLRequest {
        guard let configuration = configuration
        else { throw RequestError.requestConfigurationIsNotSet }

        guard var urlComponents = URLComponents(url: configuration.service.baseURL.appendingPathComponent(configuration.path), resolvingAgainstBaseURL: false)
        else { throw RequestError.resolvingUrlComponentsFailed }

        urlComponents.queryItems = configuration.queryItems?.map { URLQueryItem(name: $0.key, value: $0.value.description) }

        guard let url = urlComponents.url
        else { throw RequestError.resolvingUrlComponentsFailed }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = configuration.method.rawValue
        urlRequest.addValue(id.uuidString, forHTTPHeaderField: "X-Request-ID")
        configuration.headers?.forEach { urlRequest.addValue($0.value.description, forHTTPHeaderField: $0.key) }

        if let body = configuration.body {
            let data = try? configuration.requestBodyEncoder.encode(body)
            urlRequest.httpBody = data
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return urlRequest
    }
}

public extension Request {
    @inlinable func body(json: Json) -> Self {
        var request = self
        request.configuration?.body = json.root

        return request
    }

    @inlinable func body(_ data: any Codable) -> Self {
        var request = self
        request.configuration?.body = data

        return request
    }

// TODO: Implement additional modifier
// @inlinable func body(@JsonBuilder _ json: () -> [any JsonKey]) -> Self

    @inlinable func headers(@KeyValueBuilder _ items:  () -> [any KeyValueProvider]) -> Self {
        var request = self

        if var headers = request.configuration?.headers {
            headers.append(contentsOf: items())
            request.configuration?.headers = headers
        } else {
            request.configuration?.headers = items()
        }

        return request
    }

    @inlinable func queryItems(@KeyValueBuilder _ items:  () -> [any KeyValueProvider]) -> Self {
        var request = self

        if var queryItems = request.configuration?.queryItems {
            queryItems.append(contentsOf: items())
            request.configuration?.queryItems = queryItems
        } else {
            request.configuration?.queryItems = items()
        }

        return request
    }

    @inlinable func authorize() -> Self {
        guard let configuration else { return self }
        return configuration.service.authorizationProvider?.authorize(self) ?? self
    }

    @inlinable func authorize(_ authorize: (Self) -> Self) -> Self {
        authorize(self)
    }
}

public extension Request {
    var description: String {
        var array = [String]()
        array.append("• Request<\(id)>: " + String(describing: type(of: self)))

        if let configuration {
            array.append(configuration.description)
        } else {
            array.append("No content")
        }

        return array.joined(separator: "\n") + "\n"
    }
}
