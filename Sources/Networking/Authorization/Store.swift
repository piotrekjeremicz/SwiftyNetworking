//
//  Store.swift
//  
//
//  Created by Piotrek Jeremicz on 10/05/2023.
//

import Foundation

public struct AuthorizationStore {
    public enum Value {
        case token(_ value: String)
        case refreshToken(_ value: String)
        case credentials(username: String, password: String)
        
        case value(_ value: String, key: String)
    }
    
    private struct Constants {
        static let token: String = "com.jeremicz.networking.token"
        static let refreshToken: String = "com.jeremicz.networking.refresh-token"
        
        static let username: String = "com.jeremicz.networking.username"
        static let password: String = "com.jeremicz.networking.password"
    }
    
    public init() { }
    
    public func value(_ value: Value) {
        switch value {
        case .token(let value):
            print(value)
            
        case .refreshToken(let value):
            print(value)
            
        case .credentials(let username, let password):
            print(username)
            
        case .value(let value, let key):
            print(value)
        }
    }
    
    private func store(key: String, value: String) {
        
    }
}
