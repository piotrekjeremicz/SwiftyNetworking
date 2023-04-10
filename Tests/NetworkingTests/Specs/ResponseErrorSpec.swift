//
//  ResponseErrorSpec.swift
//  
//
//  Created by Piotrek on 10/07/2022.
//

import Quick
import Nimble
import Foundation
@testable import Networking

final class ResponseErrorSpec: QuickSpec {
    override func spec() {
        describe("when error occured") {
            context("response error") {
                it("is a `url` if URLError happened") {
                    let urlError = URLError(.badURL)
                    let responseError = ResponseError<Any>(urlError)
                    
                    guard case ResponseError.url(let error) = responseError else {
                        fail("")
                        return
                    }
                    expect(error).to(equal(urlError))
                }
                
                it("is a `request` if RequestError happened") {
                    let requestError = RequestError.requestConfigurationIsNotSet
                    let responseError = ResponseError<Any>(requestError)
                    
                    guard case ResponseError.request(let error) = responseError else {
                        fail("")
                        return
                    }
                    expect(error).to(equal(requestError))
                }
                
                it("is a `decoding` if DecodingError happened") {
                    let decodingError = DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: ""))
                    let responseError = ResponseError<Any>(decodingError)
                    
                    guard case ResponseError.decoding(let error) = responseError else {
                        fail("")
                        return
                    }
                    expect(error).to(beAKindOf(DecodingError.self))
                }
                
                it("is a `response`") {
                    let anotherResponseError = ResponseError<Any>.noResponse
                    let responseError = ResponseError<Any>(anotherResponseError)
                    
                    guard case ResponseError.noResponse = responseError else {
                        fail("")
                        return
                    }
                    expect(responseError).to(beAKindOf(ResponseError<Any>.self))
                }
                
                it("is an `unknown` if unknown error happened") {
                    let unknownError = MockError()
                    let responseError = ResponseError<Any>(unknownError)
                    
                    guard case ResponseError.unknown(let error) = responseError else {
                        fail("")
                        return
                    }
                    expect(error).to(beAKindOf(MockError.self))
                }
            }
        }
    }
}
