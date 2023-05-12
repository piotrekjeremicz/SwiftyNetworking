//
//  Headers.swift
//  
//
//  Created by Piotrek Jeremicz on 08/04/2023.
//

import Foundation

public struct X_Api_Key: KeyValueProvider {
    public let key: String
    public let value: any ValueBasicType

    public init(_ value: String) {
        self.key = "X-Api-Key"
        self.value = value
    }
}

public struct Authorization: KeyValueProvider {
    public let key: String
    public let value: any ValueBasicType

    public init(_ value: String) {
        self.key = "Authorization"
        self.value = value
    }
    
    public init(_ scheme: AuthorizationScheme) {
        self.key = "Authorization"
        self.value = scheme.token
    }
}
