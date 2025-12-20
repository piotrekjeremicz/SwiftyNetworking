//
//  ServiceTests.swift
//  SwiftyNetworking
//

import Testing
import Foundation
@testable import Networking

@Suite("Service Tests")
struct ServiceTests {

    @Test("Service has correct baseURL")
    func baseURL() {
        let service = MockService(baseURL: "https://api.test.com")
        #expect(service.baseURL == "https://api.test.com")
    }

    @Test("Service default logger is nil")
    func defaultLogger() {
        let service = MockService()
        #expect(service.logger == nil)
    }

    @Test("Service default interceptors are nil")
    func defaultInterceptors() {
        let service = MockService()
        #expect(service.beforeEachRequest == nil)
        #expect(service.afterEachResponse == nil)
    }

    @Test("Service default authorizationProvider is nil")
    func defaultAuthorizationProvider() {
        let service = MockService()
        #expect(service.authorizationProvider == nil)
    }
}
