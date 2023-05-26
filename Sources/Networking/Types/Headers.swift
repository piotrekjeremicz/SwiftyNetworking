//
//  Headers.swift
//  
//
//  Created by Piotrek Jeremicz on 08/04/2023.
//

import Foundation

public struct X_Api_Key: KeyValueProvider {  
    public let key: String
    public let value: String

    public init(_ key: String = "X-Api-Key", value: String) {
        self.key = key
        self.value = value
    }
}

public struct Authorization: KeyValueProvider {
    public let key: String
    public let value: String

    public init(_ key: String = "Authorization", value: String) {
        self.key = key
        self.value = value
    }
    
    public init(_ scheme: AuthorizationScheme) {
        self.key = "Authorization"
        self.value = scheme.token
    }
}
