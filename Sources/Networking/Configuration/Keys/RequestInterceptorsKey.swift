//
//  RequestInterceptorsKey.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 11.10.2025.
//

enum RequestInterceptorsKey: ConfigurationKey {
    static let defaultValue: [RequestInterceptorClosure] = []
    typealias Value = [RequestInterceptorClosure]
}

extension ConfigurationValues {
    var requestInterceptors: [RequestInterceptorClosure] {
        get { self[RequestInterceptorsKey.self] }
        set { self[RequestInterceptorsKey.self] = newValue }
    }
}
