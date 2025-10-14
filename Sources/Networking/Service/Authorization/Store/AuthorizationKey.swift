//
//  AuthorizationKey.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 12.10.2025.
//

public struct AuthorizationKey: Sendable {
    public let rawValue: String
    
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
    
    public static let accessToken = AuthorizationKey("accessToken")
    public static let refreshToken = AuthorizationKey("refreshToken")
}
