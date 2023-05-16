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

public enum AuthorizationKey: String {
    case token = "com.jeremicz.networking.token"
    case refreshToken = "com.jeremicz.networking.refresh-token"
    case username = "com.jeremicz.networking.username"
    case password = "com.jeremicz.networking.password"
}

public protocol AuthorizationStore {
    func get(key: AuthorizationKey) -> String?
    func value(_ value: AuthorizationValue)
    func remove(key: Networking.AuthorizationKey)

    func store(key: String, value: String)
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
        //TODO: Implement default keychain usage
        print(key + ": " + value)
    }

    public func remove(key: AuthorizationKey) {
        print(key)
    }
    
    public func get(key: AuthorizationKey) -> String? {
        print("get " + key.rawValue)
        return nil
    }
}
