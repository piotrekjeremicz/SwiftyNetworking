//
//  BeforeRequestModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 11.10.2025.
//

public typealias RequestInterceptorClosure = @Sendable (any Request) async -> any Request

struct BeforeRequestModifier<Content>: RequestModifier where Content: Request {
    let interceptor: RequestInterceptorClosure
    
    public func body(content: Content) -> some Request {
        var interceptors = content.configuration?.requestInterceptors ?? []
        interceptors.append(interceptor)
        
        return content.configuration(\.requestInterceptors, value: interceptors)
    }
}

public extension Request {
    func beforeRequest(_ action: @escaping RequestInterceptorClosure) -> some Request {
        modifier(
            BeforeRequestModifier(interceptor: action)
        )
    }
}
