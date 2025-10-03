//
//  ConfigurationModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 22.09.2025.
//

public extension Request {
    func configuration<Value>(
        _ keyPath: WritableKeyPath<ConfigurationValues, Value>,
        value: Value
    ) -> some Request {
        var configuration = makeRequest()
        configuration[keyPath: keyPath] = value
        
        return OverrideRequest<Self, Self.ResponseBody, Self.ResponseError>(content: self, configuration: configuration)
    }
}
