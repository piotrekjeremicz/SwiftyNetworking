//
//  HeadersKey.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 22.09.2025.
//

enum HeadersKey: ConfigurationKey {
    static let defaultValue: [String: String] = [:]
    typealias Value = [String: String]
}

public extension ConfigurationValues {
    var headers: [String: String] {
        get { self[HeadersKey.self] }
        set { self[HeadersKey.self] = newValue }
    }
}
