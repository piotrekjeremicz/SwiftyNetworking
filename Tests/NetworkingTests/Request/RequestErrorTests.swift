//
//  RequestErrorTests.swift
//  SwiftyNetworking
//

import Testing
import Foundation
@testable import Networking

@Suite("RequestError Tests")
struct RequestErrorTests {

    @Test("RequestError cases exist")
    func errorCases() {
        let missingService = RequestError.missingService
        let missingConfig = RequestError.missingConfiguration
        let resolvingFailed = RequestError.resolvingUrlComponentsFailed

        #expect(missingService == .missingService)
        #expect(missingConfig == .missingConfiguration)
        #expect(resolvingFailed == .resolvingUrlComponentsFailed)
    }
}
