//
//  Authorization.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 27.09.2025.
//

public struct Authorization: KeyValuePair {
    public let key: String
    public let value: String

    public init(bearer token: String) {
        self.key = "Authorization"
        self.value = "Bearer \(token)"
    }

    public init(_ key: String = "Authorization", value: String) {
        self.key = key
        self.value = value
    }
}
