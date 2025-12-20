//
//  KeyValuePairTests.swift
//  SwiftyNetworking
//

import Testing
import Foundation
@testable import Networking

@Suite("Key and KeyValuePair Tests")
struct KeyValuePairTests {

    @Test("Key with string value")
    func keyWithStringValue() {
        let key = Key("name", value: "John")

        #expect(key.key == "name")
        #expect(key.value == "John")
        #expect(key.description == "name: John")
    }

    @Test("Key with integer value")
    func keyWithIntValue() {
        let key = Key("age", value: 30)

        #expect(key.key == "age")
        #expect(key.value == 30)
        #expect(key.description == "age: 30")
    }

    @Test("Key with boolean value")
    func keyWithBoolValue() {
        let key = Key("active", value: true)

        #expect(key.key == "active")
        #expect(key.value == true)
        #expect(key.description == "active: true")
    }

    @Test("Key with double value")
    func keyWithDoubleValue() {
        let key = Key("price", value: 19.99)

        #expect(key.key == "price")
        #expect(key.value == 19.99)
    }

    @Test("Key with array value")
    func keyWithArrayValue() {
        let key = Key("tags", value: ["swift", "networking"])

        #expect(key.key == "tags")
        #expect(key.value == ["swift", "networking"])
    }

    @Test("Key dictionary representation")
    func keyDictionary() {
        let key = Key("name", value: "John")

        #expect(key.dictionary == ["name": "John"])
    }
}

@Suite("KeyValueBuilder Tests")
struct KeyValueBuilderTests {

    @Test("KeyValueBuilder builds array of KeyValuePairs")
    func buildBlock() {
        @KeyValueBuilder
        func build() -> [any KeyValuePair] {
            Key("name", value: "John")
            Key("age", value: 30)
        }

        let result = build()
        #expect(result.count == 2)
    }

    @Test("KeyValueBuilder builds single item")
    func buildSingleItem() {
        @KeyValueBuilder
        func build() -> [any KeyValuePair] {
            Key("name", value: "John")
        }

        let result = build()
        #expect(result.count == 1)
        #expect(result.first?.key == "name")
    }

    @Test("KeyValueBuilder builds multiple items")
    func buildMultipleItems() {
        @KeyValueBuilder
        func build() -> [any KeyValuePair] {
            Key("name", value: "John")
            Key("age", value: 30)
            Key("active", value: true)
        }

        let result = build()
        #expect(result.count == 3)
    }
}

@Suite("KeyValueGroup Tests")
struct KeyValueGroupTests {

    @Test("KeyValueGroup creates from builder")
    func createFromBuilder() {
        let group = KeyValueGroup {
            Key("name", value: "John")
            Key("age", value: 30)
        }

        #expect(group.description.contains("name"))
        #expect(group.description.contains("age"))
    }

    @Test("KeyValueGroup encodes to JSON")
    func encodesToJSON() throws {
        let group = KeyValueGroup {
            Key("name", value: "John")
            Key("active", value: true)
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(group)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"name\":\"John\""))
        #expect(json.contains("\"active\":true"))
    }
}

@Suite("Nested Key Tests")
struct NestedKeyTests {

    @Test("Key with nested KeyValueGroup")
    func nestedGroup() throws {
        let group = KeyValueGroup {
            Key("user") {
                Key("name", value: "John")
                Key("age", value: 30)
            }
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(group)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"user\""))
        #expect(json.contains("\"name\""))
        #expect(json.contains("\"age\""))
    }
}
