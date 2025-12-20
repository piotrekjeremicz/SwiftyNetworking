//
//  IntegrationTests.swift
//  SwiftyNetworking
//

import Testing
import Foundation
@testable import Networking

@Suite("Complete Request Chain Tests")
struct CompleteRequestChainTests {
    let service = MockService()

    @Test("Complete request with all modifiers")
    func completeRequest() {
        let request = Get("api", "v1", "users", from: service)
            .headers {
                ContentType.json
                Authorization(bearer: "token123")
            }
            .queryItems {
                Key("page", value: 1)
                Key("limit", value: 10)
            }
            .responseBody(MockResponseModel.self)
            .responseError(MockErrorModel.self)

        let config = request.resolveConfiguration()

        #expect(config.path == "api/v1/users")
        #expect(config.method == .get)
        #expect(config.headers["Content-Type"] == "application/json")
        #expect(config.headers["Authorization"] == "Bearer token123")
        #expect(config.queryItems["page"] == "1")
        #expect(config.queryItems["limit"] == "10")
        #expect(config.responseBodyType is MockResponseModel.Type)
        #expect(config.responseErrorType is MockErrorModel.Type)
        #expect(config.service?.baseURL == "https://api.example.com")
    }

    @Test("POST request with body")
    func postWithBody() {
        let request = Post("users", from: service)
            .headers {
                ContentType.json
            }
            .body(.json) {
                Key("name", value: "John")
                Key("email", value: "john@example.com")
            }
            .responseBody(MockResponseModel.self)

        let config = request.resolveConfiguration()

        #expect(config.path == "users")
        #expect(config.method == .post)
        #expect(config.headers["Content-Type"] == "application/json")
        #expect(config.body != nil)
    }
}
