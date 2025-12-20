//
//  QueryItemsModifierTests.swift
//  SwiftyNetworking
//

import Testing
import Foundation
@testable import Networking

@Suite("Query Items Modifier Tests")
struct QueryItemsModifierTests {
    let service = MockService()

    @Test("QueryItems modifier adds query items using dictionary")
    func queryItemsWithDictionary() {
        let request = Get("test", from: service)
            .queryItems(["page": "1", "limit": "10"])

        let config = request.resolveConfiguration()
        #expect(config.queryItems["page"] == "1")
        #expect(config.queryItems["limit"] == "10")
    }

    @Test("QueryItems modifier adds query items using builder")
    func queryItemsWithBuilder() {
        let request = Get("test", from: service)
            .queryItems {
                Key("page", value: 1)
                Key("limit", value: 10)
            }

        let config = request.resolveConfiguration()
        #expect(config.queryItems["page"] == "1")
        #expect(config.queryItems["limit"] == "10")
    }

    @Test("QueryItems modifier merges query items")
    func queryItemsMerge() {
        let request = Get("test", from: service)
            .queryItems(["page": "1"])
            .queryItems(["limit": "10"])

        let config = request.resolveConfiguration()
        #expect(config.queryItems["page"] == "1")
        #expect(config.queryItems["limit"] == "10")
    }

    @Test("QueryItems modifier with override replaces query items")
    func queryItemsOverride() {
        let request = Get("test", from: service)
            .queryItems(["page": "1", "limit": "10"])
            .queryItems(override: true, ["filter": "active"])

        let config = request.resolveConfiguration()
        #expect(config.queryItems["page"] == nil)
        #expect(config.queryItems["limit"] == nil)
        #expect(config.queryItems["filter"] == "active")
    }
}
