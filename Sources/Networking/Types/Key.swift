//
//  Key.swift
//  
//
//  Created by Piotrek Jeremicz on 08/04/2023.
//

import Foundation

public struct Key: KeyValueProvider {
    public let key: String
    public let value: any ValueBasicType

    public init(_ key: String, value: any ValueBasicType) {
        self.key = key
        self.value = value
    }

    public init(_ key: String, @JsonBuilder json: () -> [any JsonKey]) {
        self.key = key
        self.value = json() as? (any ValueBasicType) ?? Array<Key>()
    }
}
