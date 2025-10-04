//
//  RequestModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 19.09.2025.
//

public protocol RequestModifier: Sendable {
    associatedtype Body: Request
    associatedtype Content: Request
    
    func body(content: Self.Content) -> Self.Body
}

public extension Request {
    func modifier<T>(_ modifier: T) -> ModifiedRequest<Self, T> {
        ModifiedRequest(content: self, modifier: modifier)
    }
}
