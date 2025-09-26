//
//  Key.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 26.09.2025.
//

public struct Key<V>: @MainActor KeyValuePair where V: ValueBasicType {
    public let key: String
    public let value: V

    public init(_ key: String, value: V) {
        self.key = key
        self.value = value
    }
}
