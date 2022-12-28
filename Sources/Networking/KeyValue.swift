//
//  File.swift
//  
//
//  Created by Piotrek Jeremicz on 23/12/2022.
//

import Foundation

public protocol KeyValueProvider: Equatable {
    var key: String { get }
    var value: String { get }
    var dictionary: [String: String] { get }
}

extension KeyValueProvider {
    public var dictionary: [String: String] { [key: value] }
}

public struct Key: KeyValueProvider {
    public let key: String
    public let value: String

    public init(_ key: String, value: String) {
        self.key = key
        self.value = value
    }
}

public struct X_Api_Key: KeyValueProvider {
    public let key: String
    public let value: String

    public init(_ value: String) {
        self.key = "X-Api-Key"
        self.value = value
    }
}

public struct Authorization: KeyValueProvider {
    public let key: String
    public let value: String
    
    public init(_ value: String) {
        self.key = "Authorization"
        self.value = value
    }
}

@resultBuilder
public struct KeyValueBuilder {
    public static func buildBlock(_ components: any KeyValueProvider...) -> [any KeyValueProvider] {
        components
    }

    public static func buildEither(first component: [any KeyValueProvider]) -> [any KeyValueProvider] {
        component
    }

    public static func buildEither(second component: [any KeyValueProvider]) -> [any KeyValueProvider] {
        component
    }

    public static func buildArray(_ components: [[any KeyValueProvider]]) -> [any KeyValueProvider] {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [any KeyValueProvider]?) -> [any KeyValueProvider] {
        component ?? []
    }
}
