//
//  RequestSpec.swift
//  
//
//  Created by Piotrek on 09/07/2022.
//

import Quick
import Nimble
import Foundation
@testable import Networking

final class RequestSpec: QuickSpec {
    override func spec() {
        let service = MockService()
        
        describe("creating") {
            context("a request") {
                var request = MockRequest(service: service)
                
                it("should have proper generic request") {
                    let genericRequest = request.body
                    expect(genericRequest.body).to(beAKindOf(EmptyRequest.self))
                    expect(genericRequest.content).toNever(beNil())
                }
                
                it("should create proper URLRequest") {
                    expect(try request.urlRequest()).toNever(throwError())
                }
                
                let urlRequest = try! request.urlRequest()
                it("should set proper url with query items") {
                    expect(urlRequest.url).to(equal(URL(string: "https://example.com/getArticles?index=1")))
                }
                
                it("should set a GET method") {
                    expect(urlRequest.httpMethod).to(equal("GET"))
                }
                
                it("should set a Authorization header") {
                    guard let headers = urlRequest.allHTTPHeaderFields else {
                        fail("headers are not exist")
                        return
                    }
                    expect(urlRequest.allHTTPHeaderFields).toNever(beNil())
                    
                    guard let authorization = headers["Authorization"] else {
                        fail("authorization key does not exist in headers fields")
                        return
                    }
                    expect(authorization).to(equal("secret_token"))
                }

                it("should set headers properly") {
                    guard let headers = urlRequest.allHTTPHeaderFields else {
                        fail("headers are not exist")
                        return
                    }
                    
                    expect(headers.keys).to(contain("Authorization"))
                    expect(headers.values).to(contain("secret_token"))

                    expect(headers.keys).to(contain("key"))
                    expect(headers.values).to(contain("value"))
                }
                
                it("should contains proper body") {
                    guard let body = urlRequest.httpBody else {
                        fail("body does not exist")
                        return
                    }
                    
                    do {
                        let mockBody = try JSONDecoder().decode(MockBody.self, from: body)
                        expect(mockBody).to(equal(MockBody(filter: "all")))
                    } catch {
                        fail("json decoder failed with error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
