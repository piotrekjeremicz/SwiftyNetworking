//
//  HeaderTypesTests.swift
//  SwiftyNetworking
//

import Testing
import Foundation
@testable import Networking

@Suite("ContentType Tests")
struct ContentTypeTests {

    @Test("ContentType plainText")
    func plainText() {
        let contentType = ContentType.plainText

        #expect(contentType.key == "Content-Type")
        #expect(contentType.value == "text/plain")
    }

    @Test("ContentType json")
    func json() {
        let contentType = ContentType.json

        #expect(contentType.key == "Content-Type")
        #expect(contentType.value == "application/json")
    }

    @Test("ContentType formURLEncoded")
    func formURLEncoded() {
        let contentType = ContentType.formURLEncoded

        #expect(contentType.key == "Content-Type")
        #expect(contentType.value == "application/x-www-form-urlencoded")
    }

    @Test("ContentType multipartFormData")
    func multipartFormData() {
        let contentType = ContentType.multipartFormData

        #expect(contentType.key == "Content-Type")
        #expect(contentType.value == "multipart/form-data")
    }

    @Test("ContentType custom value")
    func customValue() {
        let contentType = ContentType(value: "application/xml")

        #expect(contentType.key == "Content-Type")
        #expect(contentType.value == "application/xml")
    }
}

@Suite("Authorization Header Tests")
struct AuthorizationHeaderTests {

    @Test("Authorization with bearer token")
    func bearerToken() {
        let auth = Authorization(bearer: "abc123")

        #expect(auth.key == "Authorization")
        #expect(auth.value == "Bearer abc123")
    }

    @Test("Authorization with custom value")
    func customValue() {
        let auth = Authorization(value: "Basic dXNlcjpwYXNz")

        #expect(auth.key == "Authorization")
        #expect(auth.value == "Basic dXNlcjpwYXNz")
    }
}

@Suite("ApiKey Header Tests")
struct ApiKeyHeaderTests {

    @Test("ApiKey with default key name")
    func defaultKeyName() {
        let apiKey = ApiKey(value: "my_secret_key")

        #expect(apiKey.key == "X-Api-Key")
        #expect(apiKey.value == "my_secret_key")
    }

    @Test("ApiKey with custom key name")
    func customKeyName() {
        let apiKey = ApiKey("Api-Key", value: "my_secret_key")

        #expect(apiKey.key == "Api-Key")
        #expect(apiKey.value == "my_secret_key")
    }
}
