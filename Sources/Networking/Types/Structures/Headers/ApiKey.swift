//
//  ApiKey.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 27.09.2025.
//

public struct ApiKey: KeyValuePair {
    public let key: String
    public let value: String
    
    public init(_ key: String = "X-Api-Key", value: String, ) {
        self.key = key
        self.value = value
    }
}
