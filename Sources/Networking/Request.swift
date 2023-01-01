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

public protocol Request {
    associatedtype Body: Request

    associatedtype Response: Decodable
    associatedtype ResponseError: Decodable
    
    var mock: Mock? { get set }
    var body: Body { get }
    var content: Content? { get set }

    func urlRequest() throws -> URLRequest
}

public extension Request {
    var mock: Mock? {
        get { nil }
        set {     }
    }
    var body: some Request { EmptyRequest() }
    var content: Content? {
        get { nil }
        set {     }
    }
    
    func urlRequest() throws -> URLRequest {
		let c: Content?
		if let generic = body as? any GenericRequest, let genericContent = generic.content {
			c = genericContent
		} else {
			c = content
		}
		
        guard let content = c
        else { throw RequestError.requestContentIsNotSet }
        
        guard var urlComponents = URLComponents(url: content.service.baseURL.appendingPathComponent(content.path), resolvingAgainstBaseURL: false)
        else { throw RequestError.resolvingUrlComponentsFailed }
        
		urlComponents.queryItems = content.queryItems?.map { URLQueryItem(name: $0.key, value: $0.value.description) }
        
        guard let url = urlComponents.url
        else { throw RequestError.resolvingUrlComponentsFailed }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = content.method.rawValue
		content.headers?.forEach { urlRequest.addValue($0.value.description, forHTTPHeaderField: $0.key) }
        
        if let body = content.body {
            let data = try? content.bodyEncoder.encode(body)
            urlRequest.httpBody = data
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }
    
    @inlinable func headers(@KeyValueBuilder _ items:  () -> [any KeyValueProvider]) -> some Request {
        var request = self
        request.content?.headers = items()
        
        return request
    }
    
    @inlinable func queryItems(@KeyValueBuilder _ items:  () -> [any KeyValueProvider]) -> some Request {
        var request = self
        request.content?.queryItems = items()
        
        return request
    }
	
	@inlinable func body(_ data: any Encodable) -> some Request {
		var request = self
		request.content?.body = data
		
		return request
	}
	
	@inlinable func body(@JsonBuilder _ json: () -> [any JsonKey]) -> some Request {
		var request = self
		request.content?.body = json().compactMap({ $0 as? Encodable }) as? any Encodable
		
		return request
	}
    
	@inlinable func body(json: Json) -> some Request {
		var request = self
		request.content?.body = json.root.compactMap({ $0 as? Encodable }) as? any Encodable
		
		return request
	}
	
    @inlinable func mocked(@CaseBuilder _ mock: @escaping (Mock.Request) -> [Mock.Case]) -> some Request {
        var request = self
        request.mock = Mock(flow: mock)
        
        return request
    }
}


