//
//  RetryHandlerKey.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 05.07.2026.
//

typealias RetryHandlerClosure = @Sendable (_ remainingRetries: Int) async throws -> Response<AnyCodable>

enum RetryHandlerKey: ConfigurationKey {
    static let defaultValue: RetryHandlerClosure? = nil
    typealias Value = RetryHandlerClosure?
}

extension ConfigurationValues {
    var retryHandler: RetryHandlerClosure? {
        get { self[RetryHandlerKey.self] }
        set { self[RetryHandlerKey.self] = newValue }
    }
}
