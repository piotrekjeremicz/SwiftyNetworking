//
//  ConfigurationValuesTests.swift
//  SwiftyNetworking
//

import Testing
import Foundation
@testable import Networking

@Suite("ConfigurationValues Tests")
struct ConfigurationValuesTests {

    @Test("ConfigurationValues initializes with default values")
    func defaultValues() {
        let config = ConfigurationValues()

        #expect(config.path == "")
        #expect(config.method == .get)
        #expect(config.headers.isEmpty)
        #expect(config.queryItems.isEmpty)
        #expect(config.body == nil)
        #expect(config.service == nil)
    }

    @Test("ConfigurationValues stores and retrieves path")
    func pathStorage() {
        let config = ConfigurationValues()
        config.path = "api/v1/users"

        #expect(config.path == "api/v1/users")
    }

    @Test("ConfigurationValues stores and retrieves method")
    func methodStorage() {
        let config = ConfigurationValues()
        config.method = .post

        #expect(config.method == .post)
    }

    @Test("ConfigurationValues stores and retrieves headers")
    func headersStorage() {
        let config = ConfigurationValues()
        config.headers = ["Content-Type": "application/json", "Accept": "application/json"]

        #expect(config.headers.count == 2)
        #expect(config.headers["Content-Type"] == "application/json")
        #expect(config.headers["Accept"] == "application/json")
    }

    @Test("ConfigurationValues stores and retrieves query items")
    func queryItemsStorage() {
        let config = ConfigurationValues()
        config.queryItems = ["page": "1", "limit": "10"]

        #expect(config.queryItems.count == 2)
        #expect(config.queryItems["page"] == "1")
        #expect(config.queryItems["limit"] == "10")
    }

    @Test("ConfigurationValues stores and retrieves body")
    func bodyStorage() {
        let config = ConfigurationValues()
        let bodyData = "test body".data(using: .utf8)
        config.body = bodyData

        #expect(config.body == bodyData)
    }

    @Test("ConfigurationValues stores and retrieves service")
    func serviceStorage() {
        let config = ConfigurationValues()
        let service = MockService()
        config.service = service

        #expect(config.service?.baseURL == "https://api.example.com")
    }

    @Test("ConfigurationValues debug description is not empty")
    func debugDescription() {
        let config = ConfigurationValues()
        config.path = "test/path"

        let description = config.debugDescription
        #expect(description.contains("ConfigurationValues"))
    }
}
