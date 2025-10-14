//
//  AuthorizationProvider.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 12.10.2025.
//

public protocol AuthorizationProvider: Sendable {
    var store: AuthorizationStore { get }
    
    func authorize(_ request: any Request) -> any Request
}
