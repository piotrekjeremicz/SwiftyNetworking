//
//  AfterResponseModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 11.10.2025.
//

public typealias ResponseInterceptorClosure = @Sendable (Response<AnyCodable>, any Request) -> Response<AnyCodable>

struct AfterResponseModifier<Content>: RequestModifier where Content: Request {
    let interceptor: ResponseInterceptorClosure
    
    public func body(content: Content) -> some Request {
        var interceptors = content.configuration?.responseInterceptors ?? []
        interceptors.append(interceptor)
        
        return content.configuration(\.responseInterceptors, value: interceptors)
    }
}

public extension Request {
    func afterResponse(_ perform: @escaping ResponseInterceptorClosure) -> some Request {
        modifier(
            AfterResponseModifier(interceptor: perform)
        )
    }
}
