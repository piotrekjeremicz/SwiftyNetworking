//
//  RequestMethodsTests.swift
//  SwiftyNetworking
//

import Testing
import Foundation
@testable import Networking

@Suite("HTTP Request Methods Tests")
struct RequestMethodsTests {
    let service = MockService()

    @Test("Get request sets correct method and path")
    func getRequest() {
        let request = Get("users", from: service)
        let config = request.resolveConfiguration()

        #expect(config.method == .get)
        #expect(config.path == "users")
        #expect(config.service?.baseURL == service.baseURL)
    }

    @Test("Get request with multiple path components")
    func getRequestMultiplePaths() {
        let request = Get("api", "v1", "users", from: service)
        let config = request.resolveConfiguration()

        #expect(config.path == "api/v1/users")
    }

    @Test("Post request sets correct method and path")
    func postRequest() {
        let request = Post("users", from: service)
        let config = request.resolveConfiguration()

        #expect(config.method == .post)
        #expect(config.path == "users")
    }

    @Test("Post request with multiple path components")
    func postRequestMultiplePaths() {
        let request = Post("api", "v1", "users", from: service)
        let config = request.resolveConfiguration()

        #expect(config.path == "api/v1/users")
    }

    @Test("Put request sets correct method and path")
    func putRequest() {
        let request = Put("users", "123", from: service)
        let config = request.resolveConfiguration()

        #expect(config.method == .put)
        #expect(config.path == "users/123")
    }

    @Test("Patch request sets correct method and path")
    func patchRequest() {
        let request = Patch("users", "123", from: service)
        let config = request.resolveConfiguration()

        #expect(config.method == .patch)
        #expect(config.path == "users/123")
    }

    @Test("Delete request sets correct method and path")
    func deleteRequest() {
        let request = Delete("users", "123", from: service)
        let config = request.resolveConfiguration()

        #expect(config.method == .delete)
        #expect(config.path == "users/123")
    }

    @Test("Request with CustomStringConvertible path components")
    func requestWithCustomStringConvertiblePaths() {
        let userId = 42
        let request = Get("users", userId, "profile", from: service)
        let config = request.resolveConfiguration()

        #expect(config.path == "users/42/profile")
    }
}
