//
//  File.swift
//  
//
//  Created by Piotrek Jeremicz on 07/01/2023.
//

import Foundation

public struct Response<Body: Codable> {
	public let statusCode: Int
	public let headers: [AnyHashable : Any]
	public let body: Body
	
	private let requestName: String
	private let bodyEncoder: any DataEncoder
	
	init<RequestType: Request>(_ result: (data: Data, response: URLResponse), from request: RequestType) throws {
		guard let content = request.content
		else { throw RequestError.requestContentIsNotSet }
		
		guard let httpResponse = result.response as? HTTPURLResponse
		else { throw ResponseError<Any>.unsupportedResponseType(result.response) }
		
		self.statusCode = httpResponse.statusCode
		self.headers = httpResponse.allHeaderFields
		
		guard (200..<300).contains(statusCode) else {
			if RequestType.ResponseError.self == Empty.self {
				throw ResponseError<RequestType.ResponseError>.noResponse
			} else if let errorDescription = try? content.responseDecoder.decode(RequestType.ResponseError.self, from: result.data)  {
				throw ResponseError<RequestType.ResponseError>.badResponse(httpResponse, errorDescription)
			} else {
				throw ResponseError<RequestType.ResponseError>.badResponse(httpResponse, .none)
			}
		}
		
		if Body.self == Empty.self {
			self.body = Empty() as! Body
		} else {
			self.body = try content.responseDecoder.decode(Body.self, from: result.data)
		}
		
		self.bodyEncoder = content.bodyEncoder
		self.requestName = String(describing: type(of: request))
	}
}

extension Response: CustomStringConvertible {
	public var description: String {
		var array = [String]()
		array.append("• Response: " + requestName)
		array.append("HTTP/1.1 \(statusCode) " + HTTPURLResponse.localizedString(forStatusCode: statusCode).capitalized)
		array.append(contentsOf: headers.map({ "\($0.key): \($0.value)" }))
		
		if let data = try? bodyEncoder.encode(body), let string = String(data: data, encoding: .utf8) {
			array.append("")
			array.append(string)
		}
		
		return array.joined(separator: "\n") + "\n"
	}
}
