//
//  ResponseErrorKey.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 01.10.2025.
//

enum ResponseErrorKey: ConfigurationKey {
    static let defaultValue: Any.Type = Never.self
    typealias Value = Any.Type
}

extension ConfigurationValues {
    var responseErrorType: Any.Type {
        get { self[ResponseErrorKey.self] }
        set { self[ResponseErrorKey.self] = newValue }
    }
}
