//
//  Content.swift
//  
//
//  Created by Piotrek on 18/06/2022.
//

import Combine
import Foundation

public struct Content {
	public var responseType: Codable.Type
	public var errorType: Codable.Type
	
	public var path: String
	public var service: Service
	public var method: Method
	
	public var body: (any Encodable)?
	public var headers: [any KeyValueProvider]?
	public var queryItems: [any KeyValueProvider]?
	
	public var bodyEncoder: any DataEncoder
	public var responseDecoder: any DataDecoder
	
	public var afterEach: [() -> Void] = []
	
	public init(
		responseType: Codable.Type = Empty.self,
		errorType: Codable.Type = Empty.self,
		path: [String],
		service: Service,
		method: Method,
		body: (Encodable)? = nil,
		headers: [any KeyValueProvider]? = nil,
		queryItems: [any KeyValueProvider]? = nil,
		bodyEncoder: DataEncoder,
		responseDecoder: DataDecoder
	) {
		self.responseType = responseType
		self.errorType = errorType
		self.path = path.joined(separator: "/")
		self.service = service
		self.method = method
		self.body = body
		self.headers = headers
		self.queryItems = queryItems
		self.bodyEncoder = bodyEncoder
		self.responseDecoder = responseDecoder
	}
}

extension Content: CustomStringConvertible {
	public var description: String {
		var array = [String]()
		array.append("\(method.rawValue.uppercased()) /\(path) HTTP/1.1")
		array.append("Host: \(service.baseURL)")
		
		if let headers {
			array.append(contentsOf: headers.map({ "\($0.key): \($0.value)" }))
		}
		
		if let body, let data = try? bodyEncoder.encode(body), let string = String(data: data, encoding: .utf8) {
			array.append("Content-Type: application/json")
			array.append("Content-Length: \(data.count)")
			array.append("")
			array.append(string)
		}
		
		return array.joined(separator: "\n")
	}
}
