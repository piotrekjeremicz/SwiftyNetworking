//
//  Store.swift
//  
//
//  Created by Piotrek Jeremicz on 10/05/2023.
//

import Foundation

public enum AuthorizationValue {
    case token(_ value: String)
    case refreshToken(_ value: String)
    case credentials(username: String, password: String)
    
    case value(_ value: String, key: String)
}

public protocol AuthorizationStore {
    func store(key: String, value: String)
    func value(_ value: AuthorizationValue)
}

extension AuthorizationStore {
    public func value(_ value: AuthorizationValue) {
        switch value {
        case .token(let value):
            store(key: KeychainAuthorizationStore.Constants.token, value: value)
            
        case .refreshToken(let value):
            store(key: KeychainAuthorizationStore.Constants.refreshToken, value: value)
            
        case .credentials(let username, let password):
            store(key: KeychainAuthorizationStore.Constants.username, value: username)
            store(key: KeychainAuthorizationStore.Constants.password, value: password)
            
        case .value(let value, let key):
            store(key: key, value: value)
        }
    }
}

public struct KeychainAuthorizationStore: AuthorizationStore {
    public struct Constants {
        static let token: String = "com.jeremicz.networking.token"
        static let refreshToken: String = "com.jeremicz.networking.refresh-token"
        
        static let username: String = "com.jeremicz.networking.username"
        static let password: String = "com.jeremicz.networking.password"
    }
    
    public init() { }
    
    public func store(key: String, value: String) {
        print(key + ": " + value)
    }
}
