//
//  AuthorizationStore.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 12.10.2025.
//

public protocol AuthorizationStore: Sendable {
    func set(_ key: AuthorizationKey, value: String)
    func get(_ key: AuthorizationKey) -> String?
    func remove(_ key: AuthorizationKey)
}
