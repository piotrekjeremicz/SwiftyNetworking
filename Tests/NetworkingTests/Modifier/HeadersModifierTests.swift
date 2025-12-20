//
//  HeadersModifierTests.swift
//  SwiftyNetworking
//

import Testing
import Foundation
@testable import Networking

@Suite("Headers Modifier Tests")
struct HeadersModifierTests {
    let service = MockService()

    @Test("Headers modifier adds headers using dictionary")
    func headersWithDictionary() {
        let request = Get("test", from: service)
            .headers(["Content-Type": "application/json"])

        let config = request.resolveConfiguration()
        #expect(config.headers["Content-Type"] == "application/json")
    }

    @Test("Headers modifier adds headers using builder")
    func headersWithBuilder() {
        let request = Get("test", from: service)
            .headers {
                ContentType.json
            }

        let config = request.resolveConfiguration()
        #expect(config.headers["Content-Type"] == "application/json")
    }

    @Test("Headers modifier merges headers")
    func headersMerge() {
        let request = Get("test", from: service)
            .headers(["Accept": "text/plain"])
            .headers(["Content-Type": "application/json"])

        let config = request.resolveConfiguration()
        #expect(config.headers["Accept"] == "text/plain")
        #expect(config.headers["Content-Type"] == "application/json")
    }

    @Test("Headers modifier with override replaces headers")
    func headersOverride() {
        let request = Get("test", from: service)
            .headers(["Accept": "text/plain", "Content-Type": "text/html"])
            .headers(override: true, ["Content-Type": "application/json"])

        let config = request.resolveConfiguration()
        #expect(config.headers["Accept"] == nil)
        #expect(config.headers["Content-Type"] == "application/json")
    }

    @Test("Authorization header with bearer token")
    func authorizationBearerHeader() {
        let request = Get("test", from: service)
            .headers {
                Authorization(bearer: "test_token")
            }

        let config = request.resolveConfiguration()
        #expect(config.headers["Authorization"] == "Bearer test_token")
    }

    @Test("ApiKey header")
    func apiKeyHeader() {
        let request = Get("test", from: service)
            .headers {
                ApiKey(value: "my_api_key")
            }

        let config = request.resolveConfiguration()
        #expect(config.headers["X-Api-Key"] == "my_api_key")
    }

    @Test("Multiple headers using builder")
    func multipleHeadersBuilder() {
        let request = Get("test", from: service)
            .headers {
                ContentType.json
                Authorization(bearer: "token123")
                ApiKey(value: "key123")
            }

        let config = request.resolveConfiguration()
        #expect(config.headers["Content-Type"] == "application/json")
        #expect(config.headers["Authorization"] == "Bearer token123")
        #expect(config.headers["X-Api-Key"] == "key123")
    }
}
