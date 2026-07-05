//
//  RetryCountKey.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 05.07.2026.
//

enum RetryCountKey: ConfigurationKey {
    static let defaultValue: Int = 0
    typealias Value = Int
}

public extension ConfigurationValues {
    internal(set) var retryCount: Int {
        get { self[RetryCountKey.self] }
        set { self[RetryCountKey.self] = newValue }
    }
}
