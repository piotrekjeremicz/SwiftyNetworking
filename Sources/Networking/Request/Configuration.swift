//
//  Configuration.swift
//  
//
//  Created by Piotrek Jeremicz on 02/04/2023.
//

import Foundation

public struct Configuration {
    public var path: String
    public var service: Service
    public var method: Method
    
    public var body: (any Codable)?
    public var headers: [any KeyValueProvider]?
    public var queryItems: [any KeyValueProvider]?
    
    public var bodyEncoder: (any DataEncoder)?

    internal init(
        path: [String],
        service: Service,
        method: Method,
        body: (any Codable)? = nil,
        headers: [any KeyValueProvider]? = nil,
        queryItems: [any KeyValueProvider]? = nil,
        bodyEncoder: DataEncoder?
    ) {
        self.path = path.joined(separator: "/")
        self.service = service
        self.method = method

        self.body = body
        self.headers = headers
        self.queryItems = queryItems

        self.bodyEncoder = bodyEncoder
    }
}

extension Configuration: CustomStringConvertible {
    public var description: String {
        var array = [String]()
        array.append("\(method.rawValue.uppercased()) /\(path) HTTP/1.1")
        array.append("Host: \(service.baseURL)")

        if let headers {
            array.append(contentsOf: headers.map({ "\($0.key): \($0.value)" }))
        }

        if let body, let data = try? bodyEncoder?.encode(body), let string = String(data: data, encoding: .utf8) {
            array.append("Content-Type: application/json")
            array.append("Content-Length: \(data.count)")
            array.append("")
            array.append(string)
        }

        return array.joined(separator: "\n")
    }
}
