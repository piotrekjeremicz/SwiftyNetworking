//
//  KeychainAuthorizationStore.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 12.10.2025.
//

import Foundation

public struct KeychainAuthorizationStore: AuthorizationStore {
    public init() {}

    public func set(_ key: AuthorizationKey, value: String) {
        guard let data = value.data(using: .utf8) else { return }
        save(data, account: key.rawValue)
    }
    
    public func get(_ key: AuthorizationKey) -> String? {
        guard let data = read(account: key.rawValue) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    public func remove(_ key: AuthorizationKey) {
        delete(account: key.rawValue)
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
