//
//  BodyModifierTests.swift
//  SwiftyNetworking
//

import Testing
import Foundation
@testable import Networking

@Suite("Body Modifier Tests")
struct BodyModifierTests {
    let service = MockService()

    @Test("Body modifier with Data")
    func bodyWithData() {
        let data = "test data".data(using: .utf8)!
        let request = Post("test", from: service)
            .body(data)

        let config = request.resolveConfiguration()
        #expect(config.body == data)
    }

    @Test("Body modifier with nil Data")
    func bodyWithNilData() {
        let request = Post("test", from: service)
            .body(nil)

        let config = request.resolveConfiguration()
        #expect(config.body == Data())
    }

    @Test("Body modifier with string")
    func bodyWithString() {
        let request = Post("test", from: service)
            .body(.plainText, encoding: .utf8, "Hello, World!")

        let config = request.resolveConfiguration()
        let bodyString = String(data: config.body ?? Data(), encoding: .utf8)
        #expect(bodyString == "Hello, World!")
        #expect(config.headers["Content-Type"] == "text/plain")
    }

    @Test("Body modifier with JSON using KeyValueBuilder")
    func bodyWithJSONBuilder() {
        let request = Post("test", from: service)
            .body(.json) {
                Key("name", value: "John")
                Key("age", value: 30)
            }

        let config = request.resolveConfiguration()
        #expect(config.headers["Content-Type"] == "application/json")
        #expect(config.body != nil)
    }
}
