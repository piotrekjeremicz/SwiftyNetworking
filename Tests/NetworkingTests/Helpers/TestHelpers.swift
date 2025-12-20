//
//  TestHelpers.swift
//  SwiftyNetworking
//

import Foundation
import OSLog
@testable import Networking

/// A mock service for testing purposes
struct MockService: Service {
    let baseURL: String
    var logger: Logger? = nil
    var requestBodyEncoder: any TopLevelEncoder = JSONEncoder()
    var responseBodyDecoder: any TopLevelDecoder = JSONDecoder()
    var beforeEachRequest: RequestInterceptorClosure? = nil
    var afterEachResponse: ResponseInterceptorClosure? = nil
    var authorizationProvider: AuthorizationProvider? = nil

    init(baseURL: String = "https://api.example.com") {
        self.baseURL = baseURL
    }
}

/// A mock response model for testing
struct MockResponseModel: Codable, Sendable, Equatable {
    let id: Int
    let name: String
    let active: Bool
}

/// A mock error model for testing
struct MockErrorModel: Codable, Sendable, Equatable {
    let code: Int
    let message: String
}

/// A mock authorization store for testing
final class MockAuthorizationStore: AuthorizationStore, @unchecked Sendable {
    private var storage: [String: String] = [:]

    func set(_ key: AuthorizationKey, value: String) {
        storage[key.rawValue] = value
    }

    func get(_ key: AuthorizationKey) -> String? {
        storage[key.rawValue]
    }

    func remove(_ key: AuthorizationKey) {
        storage.removeValue(forKey: key.rawValue)
    }
}
