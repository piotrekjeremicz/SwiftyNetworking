//
//  Key.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 28.09.2025.
//

public struct Key<V>: KeyValuePair where V: ValueBasicType {
    public let key: String
    public let value: V

    public init(_ key: String, value: V) {
        self.key = key
        self.value = value
    }
}

extension Key where V == KeyValueGroup {
    public init(_ key: String, @KeyValueBuilder value: () -> [any KeyValuePair]) {
        self.key = key
        self.value = KeyValueGroup(value)
    }
}
