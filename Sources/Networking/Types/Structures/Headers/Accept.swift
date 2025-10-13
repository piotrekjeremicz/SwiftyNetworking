//
//  Accept.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 27.09.2025.
//

public struct Accept: KeyValuePair {
    public let key: String
    public let value: String

    public init(_ key: String = "Accept", value: String) {
        self.key = key
        self.value = value
    }

    public static let json = Accept(value: "application/json")
}
