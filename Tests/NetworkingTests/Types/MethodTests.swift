//
//  MethodTests.swift
//  SwiftyNetworking
//

import Testing
import Foundation
@testable import Networking

@Suite("HTTP Method Tests")
struct MethodTests {

    @Test("Method enum contains all HTTP methods")
    func methodEnumValues() {
        #expect(Method.get.rawValue == "get")
        #expect(Method.post.rawValue == "post")
        #expect(Method.put.rawValue == "put")
        #expect(Method.patch.rawValue == "patch")
        #expect(Method.delete.rawValue == "delete")
    }
}
