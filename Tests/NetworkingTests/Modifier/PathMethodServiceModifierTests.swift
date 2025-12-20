//
//  PathMethodServiceModifierTests.swift
//  SwiftyNetworking
//

import Testing
import Foundation
@testable import Networking

@Suite("Path Modifier Tests")
struct PathModifierTests {
    let service = MockService()

    @Test("Path modifier sets single path")
    func singlePath() {
        let request = EmptyRequest()
            .path("users")
            .service(service)

        let config = request.resolveConfiguration()
        #expect(config.path == "users")
    }

    @Test("Path modifier sets multiple path components")
    func multiplePaths() {
        let request = EmptyRequest()
            .path("api", "v1", "users")
            .service(service)

        let config = request.resolveConfiguration()
        #expect(config.path == "api/v1/users")
    }
}

@Suite("Method Modifier Tests")
struct MethodModifierTests {
    let service = MockService()

    @Test("Method modifier sets GET")
    func setGet() {
        let request = EmptyRequest()
            .method(.get)
            .service(service)

        let config = request.resolveConfiguration()
        #expect(config.method == .get)
    }

    @Test("Method modifier sets POST")
    func setPost() {
        let request = EmptyRequest()
            .method(.post)
            .service(service)

        let config = request.resolveConfiguration()
        #expect(config.method == .post)
    }

    @Test("Method modifier sets PUT")
    func setPut() {
        let request = EmptyRequest()
            .method(.put)
            .service(service)

        let config = request.resolveConfiguration()
        #expect(config.method == .put)
    }

    @Test("Method modifier sets PATCH")
    func setPatch() {
        let request = EmptyRequest()
            .method(.patch)
            .service(service)

        let config = request.resolveConfiguration()
        #expect(config.method == .patch)
    }

    @Test("Method modifier sets DELETE")
    func setDelete() {
        let request = EmptyRequest()
            .method(.delete)
            .service(service)

        let config = request.resolveConfiguration()
        #expect(config.method == .delete)
    }
}

@Suite("Service Modifier Tests")
struct ServiceModifierTests {

    @Test("Service modifier sets service")
    func setService() {
        let service = MockService(baseURL: "https://api.test.com")
        let request = EmptyRequest()
            .service(service)

        let config = request.resolveConfiguration()
        #expect(config.service?.baseURL == "https://api.test.com")
    }
}
