//
//  AnyCodableTests.swift
//  SwiftyNetworking
//

import Testing
import Foundation
@testable import Networking

@Suite("AnyCodable Tests")
struct AnyCodableTests {

    @Test("AnyCodable with string")
    func withString() {
        let anyCodable = AnyCodable("test")
        #expect(anyCodable.value as? String == "test")
    }

    @Test("AnyCodable with int")
    func withInt() {
        let anyCodable = AnyCodable(42)
        #expect(anyCodable.value as? Int == 42)
    }

    @Test("AnyCodable with bool")
    func withBool() {
        let anyCodable = AnyCodable(true)
        #expect(anyCodable.value as? Bool == true)
    }

    @Test("AnyCodable with double")
    func withDouble() {
        let anyCodable = AnyCodable(3.14)
        #expect(anyCodable.value as? Double == 3.14)
    }

    @Test("AnyCodable with array")
    func withArray() {
        let anyCodable = AnyCodable([1, 2, 3])
        let array = anyCodable.value as? [Int]
        #expect(array == [1, 2, 3])
    }

    @Test("AnyCodable with dictionary")
    func withDictionary() {
        let anyCodable = AnyCodable(["key": "value"])
        let dict = anyCodable.value as? [String: String]
        #expect(dict == ["key": "value"])
    }

    @Test("AnyCodable with nil")
    func withNil() {
        let anyCodable = AnyCodable(nil as String?)
        #expect(anyCodable.value is Void)
    }

    @Test("AnyCodable equality - strings")
    func equalityStrings() {
        let a = AnyCodable("test")
        let b = AnyCodable("test")
        let c = AnyCodable("different")

        #expect(a == b)
        #expect(a != c)
    }

    @Test("AnyCodable equality - ints")
    func equalityInts() {
        let a = AnyCodable(42)
        let b = AnyCodable(42)
        let c = AnyCodable(43)

        #expect(a == b)
        #expect(a != c)
    }

    @Test("AnyCodable equality - bools")
    func equalityBools() {
        let a = AnyCodable(true)
        let b = AnyCodable(true)
        let c = AnyCodable(false)

        #expect(a == b)
        #expect(a != c)
    }

    @Test("AnyCodable description")
    func description() {
        let anyCodable = AnyCodable("test")
        #expect(anyCodable.description == "test")
    }

    @Test("AnyCodable debugDescription")
    func debugDescription() {
        let anyCodable = AnyCodable("test")
        #expect(anyCodable.debugDescription.contains("AnyCodable"))
    }

    @Test("AnyCodable expressible by nil literal")
    func expressibleByNilLiteral() {
        let anyCodable: AnyCodable = nil
        #expect(anyCodable.value is Void)
    }

    @Test("AnyCodable expressible by boolean literal")
    func expressibleByBooleanLiteral() {
        let anyCodable: AnyCodable = true
        #expect(anyCodable.value as? Bool == true)
    }

    @Test("AnyCodable expressible by integer literal")
    func expressibleByIntegerLiteral() {
        let anyCodable: AnyCodable = 42
        #expect(anyCodable.value as? Int == 42)
    }

    @Test("AnyCodable expressible by float literal")
    func expressibleByFloatLiteral() {
        let anyCodable: AnyCodable = 3.14
        #expect(anyCodable.value as? Double == 3.14)
    }

    @Test("AnyCodable expressible by string literal")
    func expressibleByStringLiteral() {
        let anyCodable: AnyCodable = "test"
        #expect(anyCodable.value as? String == "test")
    }

    @Test("AnyCodable expressible by array literal")
    func expressibleByArrayLiteral() {
        let anyCodable: AnyCodable = [1, 2, 3]
        // When using array literal, values are wrapped in AnyCodable
        if let array = anyCodable.value as? [AnyCodable] {
            #expect(array.count == 3)
        } else if let array = anyCodable.value as? [Int] {
            #expect(array.count == 3)
        } else {
            // Verify the value exists and is some kind of collection
            #expect(anyCodable.value is [Any])
        }
    }

    @Test("AnyCodable expressible by dictionary literal")
    func expressibleByDictionaryLiteral() {
        let anyCodable: AnyCodable = ["key": "value"]
        // When using dictionary literal, values are wrapped in AnyCodable
        if let dict = anyCodable.value as? [String: AnyCodable] {
            #expect(dict["key"]?.value as? String == "value")
        } else if let dict = anyCodable.value as? [String: String] {
            #expect(dict["key"] == "value")
        } else {
            // Verify the value exists and is some kind of dictionary
            #expect(anyCodable.value is [String: Any])
        }
    }

    @Test("AnyCodable hashable")
    func hashable() {
        let a = AnyCodable("test")
        let b = AnyCodable("test")

        var set = Set<AnyCodable>()
        set.insert(a)
        set.insert(b)

        #expect(set.count == 1)
    }

    @Test("AnyCodable encoding")
    func encoding() throws {
        let anyCodable = AnyCodable(["name": "John", "age": 30])
        let encoder = JSONEncoder()
        let data = try encoder.encode(anyCodable)

        #expect(data.count > 0)
    }

    @Test("AnyCodable decoding")
    func decoding() throws {
        let json = """
        {"name": "John", "age": 30}
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let anyCodable = try decoder.decode(AnyCodable.self, from: json)

        let dict = anyCodable.value as? [String: Any]
        #expect(dict?["name"] as? String == "John")
    }
}
