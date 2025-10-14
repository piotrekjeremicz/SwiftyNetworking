//
//  ConfigurationKey.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 21.09.2025.
//

public protocol ConfigurationKey {
    associatedtype Value
    static var defaultValue: Value { get }
}
