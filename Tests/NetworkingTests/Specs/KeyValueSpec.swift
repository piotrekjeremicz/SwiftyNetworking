//
//  KeyValueSpec.swift
//  
//
//  Created by Piotrek Jeremicz on 28/12/2022.
//

import Quick
import Nimble
import Combine
import Foundation
@testable import Networking

final class KeyValueSpec: QuickSpec {
    override func spec() {
        describe("initialize key") {
            context("as raw struct") {
                let keyValue = Key("hello", value: "world")

                expect(keyValue.key).to(equal("hello"))
                expect(keyValue.value).to(equal("world"))
                expect(keyValue.dictionary).to(equal(["hello": "world"]))
            }

            context("as key template") {
                it("is authorization") {
                    let authorization = Authorization("sample")
                    expect(authorization.dictionary).to(equal(["Authorization": "sample"]))
                }

                it("is x-api-key") {
                    let authorization = X_Api_Key("key")
                    expect(authorization.dictionary).to(equal(["X-Api-Key": "key"]))
                }
            }
        }

        describe("key value builder") {
            context("can build") {
                it("block") {
                    let block = KeyValueBuilder.buildBlock(Key("hello", value: "world"), Key("whats", value: "up")) as! [Key]
                    expect(block).to(equal([Key("hello", value: "world"), Key("whats", value: "up")]))
                }

                it("either") {
                    let first = KeyValueBuilder.buildEither(first: [Key("hello", value: "first")]) as! [Key]
                    expect(first).to(equal([Key("hello", value: "first")]))

                    let second = KeyValueBuilder.buildEither(second: [Key("hello", value: "second")]) as! [Key]
                    expect(second).to(equal([Key("hello", value: "second")]))
                }

                it("optional") {
                    let optional = KeyValueBuilder.buildOptional(nil) as! [Key]
                    expect(optional).to(equal([]))
                }

                it("array") {
                    let array = KeyValueBuilder.buildArray([[Key("hello", value: "first")], [Key("hello", value: "second")]]) as! [Key]
                    expect(array).to(equal([Key("hello", value: "first"), Key("hello", value: "second")]))
                }
            }
        }
    }
}
