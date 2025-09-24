//
//  HeaderModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 21.09.2025.
//

public struct HeaderModifier<Content>: RequestModifier where Content: Request {
    let headers: [String: String]
    
    public func body(content: Content) -> some Request {
        content.configuration(\.headers, value: headers)
    }
}

public extension Request {
    func headers(_ fields: [String: String]) -> ModifiedRequest<Self, HeaderModifier<Self>> {
        modifier(HeaderModifier(headers: fields))
    }
}
