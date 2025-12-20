//
//  ModifiedRequestTests.swift
//  SwiftyNetworking
//

import Testing
import Foundation
@testable import Networking

@Suite("ModifiedRequest Tests")
struct ModifiedRequestTests {
    let service = MockService()

    @Test("ModifiedRequest preserves configuration through chain")
    func preservesConfiguration() {
        let request = Get("users", from: service)
            .headers(["Accept": "application/json"])
            .queryItems(["page": "1"])

        let config = request.resolveConfiguration()
        #expect(config.path == "users")
        #expect(config.method == .get)
        #expect(config.headers["Accept"] == "application/json")
        #expect(config.queryItems["page"] == "1")
    }
}

@Suite("OverrideRequest Tests")
struct OverrideRequestTests {
    let service = MockService()

    @Test("OverrideRequest maintains response body type")
    func maintainsResponseBodyType() {
        let request = Get("users", from: service)
            .responseBody(MockResponseModel.self)

        let config = request.resolveConfiguration()
        #expect(config.responseBodyType is MockResponseModel.Type)
    }

    @Test("OverrideRequest maintains response error type")
    func maintainsResponseErrorType() {
        let request = Get("users", from: service)
            .responseError(MockErrorModel.self)

        let config = request.resolveConfiguration()
        #expect(config.responseErrorType is MockErrorModel.Type)
    }
}

@Suite("Request Debug Description Tests")
struct RequestDebugDescriptionTests {
    let service = MockService()

    @Test("Request has debug description")
    func hasDebugDescription() {
        let request = Get("test", from: service)
        let description = request.debugDescription

        #expect(!description.isEmpty)
    }
}
