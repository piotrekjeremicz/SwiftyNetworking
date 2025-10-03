//
//  ResponseBodyKey.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 01.10.2025.
//

enum ResponseBodyKey: ConfigurationKey {
    static var defaultValue: Any.Type = Never.self
    typealias Value = Any.Type
}

extension ConfigurationValues {
    var responseBodyType: Any.Type {
        get { self[ResponseBodyKey.self] }
        set { self[ResponseBodyKey.self] = newValue }
    }
}
