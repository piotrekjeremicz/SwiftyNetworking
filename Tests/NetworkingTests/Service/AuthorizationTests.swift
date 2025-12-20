//
//  AuthorizationTests.swift
//  SwiftyNetworking
//

import Testing
import Foundation
@testable import Networking

@Suite("AuthorizationKey Tests")
struct AuthorizationKeyTests {

    @Test("AuthorizationKey accessToken")
    func accessToken() {
        let key = AuthorizationKey.accessToken
        #expect(key.rawValue == "accessToken")
    }

    @Test("AuthorizationKey refreshToken")
    func refreshToken() {
        let key = AuthorizationKey.refreshToken
        #expect(key.rawValue == "refreshToken")
    }

    @Test("AuthorizationKey custom")
    func customKey() {
        let key = AuthorizationKey("customToken")
        #expect(key.rawValue == "customToken")
    }
}

@Suite("AuthorizationStore Tests")
struct AuthorizationStoreTests {

    @Test("MockAuthorizationStore set and get")
    func setAndGet() {
        let store = MockAuthorizationStore()
        store.set(.accessToken, value: "test_token")

        #expect(store.get(.accessToken) == "test_token")
    }

    @Test("MockAuthorizationStore remove")
    func remove() {
        let store = MockAuthorizationStore()
        store.set(.accessToken, value: "test_token")
        store.remove(.accessToken)

        #expect(store.get(.accessToken) == nil)
    }

    @Test("MockAuthorizationStore get returns nil for missing key")
    func getMissing() {
        let store = MockAuthorizationStore()

        #expect(store.get(.accessToken) == nil)
    }
}
