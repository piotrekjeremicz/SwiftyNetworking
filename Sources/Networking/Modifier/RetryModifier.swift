//
//  RetryModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 05.07.2026.
//

public extension Request {
    func retry(_ count: Int = 1) -> some Request {
        configuration(\.retryCount, value: count)
    }
}
