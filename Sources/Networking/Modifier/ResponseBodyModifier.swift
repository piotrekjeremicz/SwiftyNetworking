//
//  ResponseBodyModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 03.10.2025.
//

public extension Request {
    func responseBody<B: Codable>(_ type: B.Type) -> OverrideRequest<Self, B, Self.ResponseError> {
        let configuration = resolveConfiguration()
        configuration[keyPath: \.responseBodyType] = type
        
        return OverrideRequest<Self, B, Self.ResponseError>(content: self, configuration: configuration)
    }
}
