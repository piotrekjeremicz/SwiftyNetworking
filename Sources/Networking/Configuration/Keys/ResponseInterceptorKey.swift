//
//  ResponseInterceptorKey.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 12.10.2025.
//

enum ResponseInterceptorKey: ConfigurationKey {
    static let defaultValue: [ResponseInterceptorClosure] = []
    typealias Value = [ResponseInterceptorClosure]
}

extension ConfigurationValues {
    var responseInterceptors: [ResponseInterceptorClosure] {
        get { self[ResponseInterceptorKey.self] }
        set { self[ResponseInterceptorKey.self] = newValue }
    }
}
