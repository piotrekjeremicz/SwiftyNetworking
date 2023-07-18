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
    func get(key: String) -> String?
    func value(_ value: AuthorizationValue)
    func remove(key: String)
    
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
        save(Data(value.utf8), account: key)
    }
    
    public func remove(key: String) {
        delete(account: key)
    }
    
    public func get(key: String) -> String? {
        guard let data = read(account: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

private extension KeychainAuthorizationStore {
    func save(_ data: Data, account: String) {
        let query = [kSecValueData: data, kSecClass: kSecClassGenericPassword, kSecAttrAccount: account] as CFDictionary
        let saveStatus = SecItemAdd(query, nil)
        
        if saveStatus != errSecSuccess { print("Error: \(saveStatus)") }
        if saveStatus == errSecDuplicateItem { update(data, account: account) }
    }
    
    func update(_ data: Data, account: String) {
        let query = [kSecClass: kSecClassGenericPassword, kSecAttrAccount: account] as CFDictionary
        let updatedData = [kSecValueData: data] as CFDictionary
        
        SecItemUpdate(query, updatedData)
    }
    
    func read(account: String) -> Data? {
        let query = [kSecClass: kSecClassGenericPassword, kSecAttrAccount: account, kSecReturnData: true] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)

        return result as? Data
    }
    
    func delete(account: String) {
        let query = [kSecClass: kSecClassGenericPassword, kSecAttrAccount: account] as CFDictionary
        
        SecItemDelete(query)
    }
}
