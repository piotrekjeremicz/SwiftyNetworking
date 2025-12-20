//
//  ResponseModifierTests.swift
//  SwiftyNetworking
//

import Testing
import Foundation
@testable import Networking

@Suite("ResponseBody Modifier Tests")
struct ResponseBodyModifierTests {
    let service = MockService()

    @Test("ResponseBody modifier sets response type")
    func responseBodySetsType() {
        let request = Get("test", from: service)
            .responseBody(MockResponseModel.self)

        let config = request.resolveConfiguration()
        #expect(config.responseBodyType is MockResponseModel.Type)
    }
}

@Suite("ResponseError Modifier Tests")
struct ResponseErrorModifierTests {
    let service = MockService()

    @Test("ResponseError modifier sets error type")
    func responseErrorSetsType() {
        let request = Get("test", from: service)
            .responseError(MockErrorModel.self)

        let config = request.resolveConfiguration()
        #expect(config.responseErrorType is MockErrorModel.Type)
    }
}
