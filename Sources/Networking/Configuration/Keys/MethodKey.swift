//
//  MethodKey.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 22.09.2025.
//

enum MethodKey: ConfigurationKey {
    static let defaultValue: Method = .get
    typealias Value = Method
}

extension ConfigurationValues {
    var method: Method {
        get { self[MethodKey.self] }
        set { self[MethodKey.self] = newValue }
    }
}
