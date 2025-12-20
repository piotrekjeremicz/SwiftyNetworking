//
//  EmptyRequestTests.swift
//  SwiftyNetworking
//

import Testing
import Foundation
@testable import Networking

@Suite("EmptyRequest Tests")
struct EmptyRequestTests {

    @Test("EmptyRequest has configuration")
    func hasConfiguration() {
        let request = EmptyRequest()
        #expect(request.configuration != nil)
    }

    @Test("EmptyRequest resolves configuration")
    func resolvesConfiguration() {
        let request = EmptyRequest()
        let config = request.resolveConfiguration()
        #expect(config.method == .get)
    }
}
