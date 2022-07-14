//
//  GenericRequestSpec.swift
//  
//
//  Created by Piotrek on 09/07/2022.
//

import Quick
import Nimble
import Foundation
@testable import Networking

final class GenericRequestSpec: QuickSpec {
    override func spec() {
        let path = "path"
        let service = MockService()
        
        describe("using generic requests") {
            context("as GET") {
                let getRequest = Get(path, from: service)
                let content = Content(path: path, service: service, method: .get, bodyEncoder: JSONEncoder(), responseDecoder: JSONDecoder())
                
                it("has proper request content") {
                    expect(getRequest.content).neverTo(beNil())
                    
                    let requestContent = getRequest.content
                    expect(requestContent?.path).to(equal(content.path))
                    expect(requestContent?.service.baseURL).to(equal(content.service.baseURL))
                    expect(requestContent?.method).to(equal(content.method))
                }
            }
            
            context("as POST") {
                let postRequest = Post(path, from: service)
                let content = Content(path: path, service: service, method: .post, bodyEncoder: JSONEncoder(), responseDecoder: JSONDecoder())
                
                it("has proper request content") {
                    expect(postRequest.content).neverTo(beNil())
                    
                    let requestContent = postRequest.content
                    expect(requestContent?.path).to(equal(content.path))
                    expect(requestContent?.service.baseURL).to(equal(content.service.baseURL))
                    expect(requestContent?.method).to(equal(content.method))
                }
            }
            
            context("as PUT") {
                let putRequest = Put(path, from: service)
                let content = Content(path: path, service: service, method: .put, bodyEncoder: JSONEncoder(), responseDecoder: JSONDecoder())
                
                it("has proper request content") {
                    expect(putRequest.content).neverTo(beNil())
                    
                    let requestContent = putRequest.content
                    expect(requestContent?.path).to(equal(content.path))
                    expect(requestContent?.service.baseURL).to(equal(content.service.baseURL))
                    expect(requestContent?.method).to(equal(content.method))
                }
            }
            
            context("as PATCH") {
                let pathRequest = Patch(path, from: service)
                let content = Content(path: path, service: service, method: .patch, bodyEncoder: JSONEncoder(), responseDecoder: JSONDecoder())
                
                it("has proper request content") {
                    expect(pathRequest.content).neverTo(beNil())
                    
                    let requestContent = pathRequest.content
                    expect(requestContent?.path).to(equal(content.path))
                    expect(requestContent?.service.baseURL).to(equal(content.service.baseURL))
                    expect(requestContent?.method).to(equal(content.method))
                }
            }
            
            context("as DELETE") {
                let pathRequest = Delete(path, from: service)
                let content = Content(path: path, service: service, method: .delete, bodyEncoder: JSONEncoder(), responseDecoder: JSONDecoder())
                
                it("has proper request content") {
                    expect(pathRequest.content).neverTo(beNil())
                    
                    let requestContent = pathRequest.content
                    expect(requestContent?.path).to(equal(content.path))
                    expect(requestContent?.service.baseURL).to(equal(content.service.baseURL))
                    expect(requestContent?.method).to(equal(content.method))
                }
            }
        }
    }
}
