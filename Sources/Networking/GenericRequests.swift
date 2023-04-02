//
//  Requests.swift
//  
//
//  Created by Piotrek on 18/06/2022.
//

import Combine
import Foundation

protocol GenericRequest: Old_Request {
    init(_ path: String..., from service: Service, bodyEncoder: (any DataEncoder)?, responseDecoder: (any DataDecoder)?)
    init<ResponseBody>(responseBody: ResponseBody.Type, path: [String], from service: Service, bodyEncoder: (any DataEncoder)?, responseDecoder: (any DataDecoder)?) where ResponseBody: Codable
    init<ResponseBody>(responseBody: ResponseBody.Type, path: String..., from service: Service, bodyEncoder: (any DataEncoder)?, responseDecoder: (any DataDecoder)?) where ResponseBody: Codable
}

extension GenericRequest {
    public init<ResponseBody>(responseBody: ResponseBody.Type, path: String..., from service: Service, bodyEncoder: (any DataEncoder)? = nil, responseDecoder: (any DataDecoder)? = nil) where ResponseBody: Codable {
        self.init(responseBody: responseBody, path: path, from: service, bodyEncoder: bodyEncoder, responseDecoder: responseDecoder)
    }
    
    public init(_ path: String..., from service: Service, bodyEncoder: (any DataEncoder)? = nil, responseDecoder: (any DataDecoder)? = nil) {
        self.init(responseBody: Empty.self, path: path, from: service, bodyEncoder: bodyEncoder, responseDecoder: responseDecoder)
    }
}

public struct EmptyRequest: GenericRequest {
    public typealias ResponseBody = Empty
    public typealias ResponseError = Empty
    
    public var content: Content?
    
    public init() {
        content = nil
    }
    
    public init<ResponseBody>(responseBody: ResponseBody.Type, path: [String], from service: Service, bodyEncoder: (DataEncoder)?, responseDecoder: (DataDecoder)?) where ResponseBody : Decodable, ResponseBody : Encodable {
        self.init()
    }
}

public struct Get: GenericRequest {
    public typealias ResponseBody = Empty
    public typealias ResponseError = Empty
    
    public var content: Content?
    
    public init<ResponseBody>(responseBody: ResponseBody.Type, path: [String], from service: Service, bodyEncoder: (any DataEncoder)? = nil, responseDecoder: (any DataDecoder)? = nil) where ResponseBody: Codable {
        let bodyEncoder = bodyEncoder == nil ? service.requestBodyEncoder : bodyEncoder!
        let responseDecoder = responseDecoder == nil ? service.responseBodyDecoder : responseDecoder!
        
        content = Content(
            responseType: ResponseBody.self,
            path: path,
            service: service,
            method: .get,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}

public struct Post: GenericRequest {
    public typealias ResponseBody = Empty
    public typealias ResponseError = Empty
    
    public var content: Content?
    
    public init<ResponseBody>(responseBody: ResponseBody.Type, path: [String], from service: Service, bodyEncoder: (any DataEncoder)? = nil, responseDecoder: (any DataDecoder)? = nil) where ResponseBody: Codable {
        let bodyEncoder = bodyEncoder == nil ? service.requestBodyEncoder : bodyEncoder!
        let responseDecoder = responseDecoder == nil ? service.responseBodyDecoder : responseDecoder!
        
        content = Content(
            responseType: ResponseBody.self,
            path: path,
            service: service,
            method: .post,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}

public struct Put: GenericRequest {
    public typealias ResponseBody = Empty
    public typealias ResponseError = Empty
    
    public var content: Content?
    
    public init<ResponseBody>(responseBody: ResponseBody.Type, path: [String], from service: Service, bodyEncoder: (any DataEncoder)? = nil, responseDecoder: (any DataDecoder)? = nil) where ResponseBody: Codable {
        let bodyEncoder = bodyEncoder == nil ? service.requestBodyEncoder : bodyEncoder!
        let responseDecoder = responseDecoder == nil ? service.responseBodyDecoder : responseDecoder!
        
        content = Content(
            responseType: ResponseBody.self,
            path: path,
            service: service,
            method: .put,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}

public struct Patch: GenericRequest {
    public typealias ResponseBody = Empty
    public typealias ResponseError = Empty
    
    public var content: Content?
    
    public init<ResponseBody>(responseBody: ResponseBody.Type, path: [String], from service: Service, bodyEncoder: (any DataEncoder)? = nil, responseDecoder: (any DataDecoder)? = nil) where ResponseBody: Codable {
        let bodyEncoder = bodyEncoder == nil ? service.requestBodyEncoder : bodyEncoder!
        let responseDecoder = responseDecoder == nil ? service.responseBodyDecoder : responseDecoder!
        
        content = Content(
            responseType: ResponseBody.self,
            path: path,
            service: service,
            method: .patch,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}

public struct Delete: GenericRequest {
    public typealias ResponseBody = Empty
    public typealias ResponseError = Empty
    
    public var content: Content?
    
    public init<ResponseBody>(responseBody: ResponseBody.Type, path: [String], from service: Service, bodyEncoder: (any DataEncoder)? = nil, responseDecoder: (any DataDecoder)? = nil) where ResponseBody: Codable {
        let bodyEncoder = bodyEncoder == nil ? service.requestBodyEncoder : bodyEncoder!
        let responseDecoder = responseDecoder == nil ? service.responseBodyDecoder : responseDecoder!
        
        content = Content(
            responseType: ResponseBody.self,
            path: path,
            service: service,
            method: .delete,
            bodyEncoder: bodyEncoder,
            responseDecoder: responseDecoder
        )
    }
}
