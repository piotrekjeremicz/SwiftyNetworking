//
//  MethodModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 20.09.2025.
//

public struct MethodModifier<Content>: RequestModifier where Content: Request {
    let method: Method
    
    public func body(content: Content) -> some Request {
        content.configuration(\.method, value: method)
    }
}

public extension Request {
    func method(_ method: Method) -> some Request {
        modifier(MethodModifier(method: method))
    }
}
