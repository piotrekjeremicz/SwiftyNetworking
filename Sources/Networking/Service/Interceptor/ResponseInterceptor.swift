//
//  ResponseInterceptor.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 11.10.2025.
//


public protocol ResponseInterceptor: Sendable {
    func intercept<R: Request>(_ response: R.ResponseBody, for request: R) async throws -> R.ResponseBody
}
