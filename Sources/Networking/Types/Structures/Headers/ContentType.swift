//
//  ContentType.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 27.09.2025.
//

public struct ContentType: @MainActor KeyValuePair {
    public let key: String
    public let value: String

    public init(_ key: String = "Content-Type", value: String) {
        self.key = key
        self.value = value
    }

    public static let plainText = ContentType(value: "text/plain")
    public static let json = ContentType(value: "application/json")
    public static let formURLEncoded = ContentType(value: "application/x-www-form-urlencoded")
    public static let multipartFormData = ContentType(value: "multipart/form-data")
}
