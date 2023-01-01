//
//  ServiceSpec.swift
//  
//
//  Created by Piotrek Jeremicz on 29/12/2022.
//

import Quick
import Nimble
import Combine
import Foundation
@testable import Networking

final class ServiceSpec: QuickSpec {
    override func spec() {
        describe("service") {
            context("as simple structure") {
                let simpleService = MockSimpleService()

                it("has proper base url") {
                    expect(simpleService.baseURL.absoluteString).to(equal("https://example.com"))
                }

                it("has default coders") {
                    expect(simpleService.bodyEncoder).to(beAKindOf(JSONEncoder.self))
                    expect(simpleService.responseDecoder).to(beAKindOf(JSONDecoder.self))
                }
            }
        }
    }
}
