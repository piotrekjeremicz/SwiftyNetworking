//
//  Key.swift
//  
//
//  Created by Piotrek Jeremicz on 08/04/2023.
//

import Foundation

public struct Key<V>: KeyValueProvider where V: ValueBasicType {
    public let key: String
    public let value: V

    public init(_ key: String, value: V) {
        self.key = key
        self.value = value
    }
}
