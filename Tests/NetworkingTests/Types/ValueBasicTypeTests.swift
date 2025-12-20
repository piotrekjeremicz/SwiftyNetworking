//
//  ValueBasicTypeTests.swift
//  SwiftyNetworking
//

import Testing
import Foundation
@testable import Networking

@Suite("ValueBasicType Tests")
struct ValueBasicTypeTests {

    @Test("Int conforms to ValueBasicType")
    func intConforms() {
        let value: any ValueBasicType = 42
        #expect(value.description == "42")
    }

    @Test("Bool conforms to ValueBasicType")
    func boolConforms() {
        let value: any ValueBasicType = true
        #expect(value.description == "true")
    }

    @Test("Double conforms to ValueBasicType")
    func doubleConforms() {
        let value: any ValueBasicType = 3.14
        #expect(value.description == "3.14")
    }

    @Test("String conforms to ValueBasicType")
    func stringConforms() {
        let value: any ValueBasicType = "test"
        #expect(value.description == "test")
    }

    @Test("Array of ValueBasicType conforms")
    func arrayConforms() {
        let value: any ValueBasicType = ["a", "b", "c"]
        #expect(value.description.contains("a"))
    }

    @Test("Optional ValueBasicType description for nil")
    func optionalNilDescription() {
        let value: String? = nil
        #expect(value.description == "null")
    }

    @Test("Optional ValueBasicType description for some")
    func optionalSomeDescription() {
        let value: String? = "test"
        #expect(value.description == "test")
    }
}
