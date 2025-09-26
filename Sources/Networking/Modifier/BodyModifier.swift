//
//  BodyModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 21.09.2025.
//

import Foundation

public struct BodyModifier<Content>: RequestModifier where Content: Request {
    let body: Data
    
    public func body(content: Content) -> some Request {
        content.configuration(\.body, value: body)
    }
}

public extension Request {
    func body(_ data: Data?) -> ModifiedRequest<Self, BodyModifier<Self>> {
        modifier(BodyModifier(body: data ?? Data()))
    }
    
    func body(@KeyValueBuilder _ items: () -> [any KeyValuePair]) -> ModifiedRequest<Self, BodyModifier<Self>> {
        modifier(
            BodyModifier(
                body: (try? JSONEncoder().encode(KeyValueGroup(items))) ?? Data()
            )
        )
    }
}
