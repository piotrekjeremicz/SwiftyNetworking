//
//  RequestInterceptor.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 11.10.2025.
//

public protocol RequestInterceptor: Sendable {
    func intercept<R: Request>(_ request: R) async throws -> R
}
