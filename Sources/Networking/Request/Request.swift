//
//  Request.swift
//  
//
//  Created by Piotrek on 18/06/2022.
//

import Foundation
import Combine

public enum Method: String {
    case get
    case put
    case post
    case patch
    case delete
}

public protocol Request: CustomStringConvertible {
    associatedtype Body: Request

    var id: UUID { get }
    var body: Body { get }

    var configuration: Configuration? { get set }
}

public extension Request {
    var id: UUID { UUID() }
    var body: some Request { EmptyRequest() }

    var configuration: Configuration? {
        get {
            let anyConfiguration: Configuration?
            
            if let method = body as? any HttpRequest, let methodConfiguration = method.configuration {
                anyConfiguration = methodConfiguration
            } else {
                anyConfiguration = nil
            }

            return anyConfiguration
        }

        set {     }
    }
}

public extension Request {
    @inlinable func body(json: Json) -> Self {
        var request = self
        request.configuration?.body = json.root.compactMap({ $0 as? Codable }) as? any Codable

        return request
    }

    @inlinable func body(_ data: any Codable) -> Self {
        var request = self
        request.configuration?.body = data

        return request
    }

    @inlinable func body(@JsonBuilder _ json: () -> [any JsonKey]) -> Self {
        var request = self
        request.configuration?.body = json().compactMap({ $0 as? Codable }) as? any Codable

        return request
    }

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
}

public extension Request {
    var description: String {
        var array = [String]()
        array.append("• Request: " + String(describing: type(of: self)))

        if let configuration {
            array.append(configuration.description)
        } else {
            array.append("No content")
        }

        return array.joined(separator: "\n") + "\n"
    }
}











public protocol Old_Request: CustomStringConvertible {
    associatedtype Body: Old_Request

    associatedtype ResponseBody: Codable
    associatedtype ResponseError: Codable
    
    var id: UUID { get }
    
    var mock: Mock? { get set }
    var body: Body { get }
    var content: Content? { get set }

    func urlRequest() throws -> URLRequest
}

public extension Old_Request {
    var id: UUID { UUID() }
    
    var mock: Mock? {
        get { nil }
        set {     }
    }
	
    var body: some Old_Request { Old_EmptyRequest() }
	
    var content: Content? {
		get {
			let anyContent: Content?
			if let generic = body as? any GenericRequest, let genericContent = generic.content {
				anyContent = genericContent
			} else {
				anyContent = nil
			}
			
			return anyContent
		}
		
        set {     }
    }
    
    func urlRequest() throws -> URLRequest {
        guard let content = content
        else { throw RequestError.requestContentIsNotSet }
        
        guard var urlComponents = URLComponents(url: content.service.baseURL.appendingPathComponent(content.path), resolvingAgainstBaseURL: false)
        else { throw RequestError.resolvingUrlComponentsFailed }
        
		urlComponents.queryItems = content.queryItems?.map { URLQueryItem(name: $0.key, value: $0.value.description) }
        
        guard let url = urlComponents.url
        else { throw RequestError.resolvingUrlComponentsFailed }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = content.method.rawValue
        urlRequest.addValue(id.uuidString, forHTTPHeaderField: "X-Request-ID")
        content.headers?.forEach { urlRequest.addValue($0.value.description, forHTTPHeaderField: $0.key) }
        
        if let body = content.body {
            let data = try? content.bodyEncoder.encode(body)
            urlRequest.httpBody = data
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }
}

public extension Old_Request {
    @inlinable func headers(@KeyValueBuilder _ items:  () -> [any KeyValueProvider]) -> Self {
        var request = self

        if var headers = request.content?.headers {
            headers.append(contentsOf: items())
            request.content?.headers = headers
        } else {
            request.content?.headers = items()
        }

        return request
    }

    @inlinable func queryItems(@KeyValueBuilder _ items:  () -> [any KeyValueProvider]) -> Self {
        var request = self
        request.content?.queryItems = items()

        return request
    }

    @inlinable func body(_ data: any Encodable) -> Self {
        var request = self
        request.content?.body = data

        return request
    }

    @inlinable func body(@JsonBuilder _ json: () -> [any JsonKey]) -> Self {
        var request = self
        request.content?.body = json().compactMap({ $0 as? Encodable }) as? any Encodable

        return request
    }

    @inlinable func body(json: Json) -> Self {
        var request = self
        request.content?.body = json.root.compactMap({ $0 as? Encodable }) as? any Encodable

        return request
    }

    @inlinable func mocked(@CaseBuilder _ mock: @escaping (Mock.Request) -> [Mock.Case]) -> Self {
        var request = self
        request.mock = Mock(flow: mock)

        return request
    }

    @inlinable func authorized() -> Self {
        guard let content else { return self }
        return content.service.authorize(self)
    }

    @inlinable func authorized(_ authorize: (Self) -> Self) -> Self {
        authorize(self)
    }
}


extension Old_Request {
	public var description: String {
		var array = [String]()
		array.append("• Request: " + String(describing: type(of: self)))
		
		if let content {
			array.append(content.description)
		} else {
			array.append("No content")
		}
		
		return array.joined(separator: "\n") + "\n"
	}
}
