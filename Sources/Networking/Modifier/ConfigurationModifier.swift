//
//  ConfigurationModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 22.09.2025.
//

public struct ConfigurationModifier<Content, Value>: RequestModifier where Content: Request {
    public var value: Value
    public var keyPath: WritableKeyPath<ConfigurationValues, Value>
    
    public func body(content: Content) -> some Request {
        var content = content
        content.configuration?[keyPath: keyPath] = value
        
        return content
    }
}

public extension Request {
    func configuration<Value>(
        _ keyPath: WritableKeyPath<ConfigurationValues, Value>,
        value: Value
    ) -> Self {
        var request = self
        request.configuration?[keyPath: keyPath] = value
        
        return request
    }
}
