//
//  Store.swift
//
//
//  Created by Piotrek Jeremicz on 10/05/2023.
//

import Foundation

public enum AuthorizationKey {
    case token, refreshToken, username, password
    case raw(_ key: String)
    
    public func representant<Store: AuthorizationStore>(for type: Store.Type) -> String {
        switch self {
        case .token:
            return Store.tokenKey
        case .refreshToken:
            return Store.refreshTokenKey
        case .username:
            return Store.usernameKey
        case .password:
            return Store.passwordKey
        case .raw(let key):
            return key
        }
    }
}

public enum AuthorizationValue {
    case token(_ value: String)
    case refreshToken(_ value: String)
    case credentials(username: String, password: String)
    
    case value(_ value: String, key: String)
}

public protocol AuthorizationStore {
    static var tokenKey: String { get }
    static var refreshTokenKey: String { get }
    static var usernameKey: String { get }
    static var passwordKey: String { get }
    
    func get(key: AuthorizationKey) -> String?
    func save(_ value: AuthorizationValue)
    func remove(key: AuthorizationKey)
    
    func store(key: AuthorizationKey, value: String)
}

extension AuthorizationStore {
    public static var tokenKey: String { KeychainAuthorizationStore.Constants.token }
    public static var refreshTokenKey: String { KeychainAuthorizationStore.Constants.refreshToken }
    public static var usernameKey: String { KeychainAuthorizationStore.Constants.username }
    public static var passwordKey: String { KeychainAuthorizationStore.Constants.password }
    
    public func save(_ value: AuthorizationValue) {
        switch value {
        case .token(let value):
            store(key: .token, value: value)
            
        case .refreshToken(let value):
            store(key: .refreshToken, value: value)
            
        case .credentials(let username, let password):
            store(key: .username, value: username)
            store(key: .password, value: password)
            
        case .value(let value, let key):
            store(key: .raw(key), value: value)
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
    
    public func store(key: AuthorizationKey, value: String) {
        save(Data(value.utf8), account: key.representant(for: Self.self))
    }
    
    public func remove(key: AuthorizationKey) {
        delete(account: key.representant(for: Self.self))
    }
    
    public func get(key: AuthorizationKey) -> String? {
        guard let data = read(account: key.representant(for: Self.self)) else { return nil }
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
