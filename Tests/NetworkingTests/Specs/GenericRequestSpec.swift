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
        let path = ["path", "to", "endpoint"]
        let service = MockService()
        
        describe("using generic requests") {
            context("as GET") {
                let getRequest = Old_Get("path", "to", "endpoint", from: service)
                let content = Content(path: path, service: service, method: .get, bodyEncoder: JSONEncoder(), responseDecoder: JSONDecoder())
                
                it("has proper request content") {
                    expect(getRequest.content).neverTo(beNil())
                    
                    let requestContent = getRequest.content
                    expect(requestContent?.path).to(equal(content.path))
                    expect(requestContent?.service.baseURL).to(equal(content.service.baseURL))
                    expect(requestContent?.method).to(equal(content.method))
                }

                it("has default coder inherited from service") {
                    let bodyEncoder = getRequest.content?.bodyEncoder as? JSONEncoder
                    expect(bodyEncoder).neverTo(beNil())
                    expect(bodyEncoder!.userInfo.keys.first?.rawValue).to(equal("test"))

                    let responseDecoder = getRequest.content?.responseDecoder as? JSONDecoder
                    expect(responseDecoder).neverTo(beNil())
                    expect(responseDecoder!.userInfo.keys.first?.rawValue).to(equal("test"))
                }

                it("can handle custom coder") {
                    let customRequest = Old_Get("path", "to", "endpoint", from: service, bodyEncoder: JSONEncoder(), responseDecoder: JSONDecoder())

                    let bodyEncoder = customRequest.content?.bodyEncoder as? JSONEncoder
                    expect(bodyEncoder).neverTo(beNil())
                    expect(bodyEncoder?.userInfo).to(beEmpty())

                    let responseDecoder = customRequest.content?.responseDecoder as? JSONDecoder
                    expect(responseDecoder).neverTo(beNil())
                    expect(responseDecoder?.userInfo).to(beEmpty())
                }
            }
            
            context("as POST") {
                let postRequest = Old_Post("path", "to", "endpoint", from: service)
                let content = Content(path: path, service: service, method: .post, bodyEncoder: JSONEncoder(), responseDecoder: JSONDecoder())
                
                it("has proper request content") {
                    expect(postRequest.content).neverTo(beNil())
                    
                    let requestContent = postRequest.content
                    expect(requestContent?.path).to(equal(content.path))
                    expect(requestContent?.service.baseURL).to(equal(content.service.baseURL))
                    expect(requestContent?.method).to(equal(content.method))
                }

                it("has default coder inherited from service") {
                    let bodyEncoder = postRequest.content?.bodyEncoder as? JSONEncoder
                    expect(bodyEncoder).neverTo(beNil())
                    expect(bodyEncoder!.userInfo.keys.first?.rawValue).to(equal("test"))

                    let responseDecoder = postRequest.content?.responseDecoder as? JSONDecoder
                    expect(responseDecoder).neverTo(beNil())
                    expect(responseDecoder!.userInfo.keys.first?.rawValue).to(equal("test"))
                }

                it("can handle custom coder") {
                    let customRequest = Old_Post("path", "to", "endpoint", from: service, bodyEncoder: JSONEncoder(), responseDecoder: JSONDecoder())

                    let bodyEncoder = customRequest.content?.bodyEncoder as? JSONEncoder
                    expect(bodyEncoder).neverTo(beNil())
                    expect(bodyEncoder?.userInfo).to(beEmpty())

                    let responseDecoder = customRequest.content?.responseDecoder as? JSONDecoder
                    expect(responseDecoder).neverTo(beNil())
                    expect(responseDecoder?.userInfo).to(beEmpty())
                }
            }
            
            context("as PUT") {
                let putRequest = Old_Put("path", "to", "endpoint", from: service)
                let content = Content(path: path, service: service, method: .put, bodyEncoder: JSONEncoder(), responseDecoder: JSONDecoder())
                
                it("has proper request content") {
                    expect(putRequest.content).neverTo(beNil())
                    
                    let requestContent = putRequest.content
                    expect(requestContent?.path).to(equal(content.path))
                    expect(requestContent?.service.baseURL).to(equal(content.service.baseURL))
                    expect(requestContent?.method).to(equal(content.method))
                }

                it("has default coder inherited from service") {
                    let bodyEncoder = putRequest.content?.bodyEncoder as? JSONEncoder
                    expect(bodyEncoder).neverTo(beNil())
                    expect(bodyEncoder!.userInfo.keys.first?.rawValue).to(equal("test"))

                    let responseDecoder = putRequest.content?.responseDecoder as? JSONDecoder
                    expect(responseDecoder).neverTo(beNil())
                    expect(responseDecoder!.userInfo.keys.first?.rawValue).to(equal("test"))
                }

                it("can handle custom coder") {
                    let customRequest = Old_Put("path", "to", "endpoint", from: service, bodyEncoder: JSONEncoder(), responseDecoder: JSONDecoder())

                    let bodyEncoder = customRequest.content?.bodyEncoder as? JSONEncoder
                    expect(bodyEncoder).neverTo(beNil())
                    expect(bodyEncoder?.userInfo).to(beEmpty())

                    let responseDecoder = customRequest.content?.responseDecoder as? JSONDecoder
                    expect(responseDecoder).neverTo(beNil())
                    expect(responseDecoder?.userInfo).to(beEmpty())
                }
            }
            
            context("as PATCH") {
                let pathRequest = Old_Patch("path", "to", "endpoint", from: service)
                let content = Content(path: path, service: service, method: .patch, bodyEncoder: JSONEncoder(), responseDecoder: JSONDecoder())
                
                it("has proper request content") {
                    expect(pathRequest.content).neverTo(beNil())
                    
                    let requestContent = pathRequest.content
                    expect(requestContent?.path).to(equal(content.path))
                    expect(requestContent?.service.baseURL).to(equal(content.service.baseURL))
                    expect(requestContent?.method).to(equal(content.method))
                }

                it("has default coder inherited from service") {
                    let bodyEncoder = pathRequest.content?.bodyEncoder as? JSONEncoder
                    expect(bodyEncoder).neverTo(beNil())
                    expect(bodyEncoder!.userInfo.keys.first?.rawValue).to(equal("test"))

                    let responseDecoder = pathRequest.content?.responseDecoder as? JSONDecoder
                    expect(responseDecoder).neverTo(beNil())
                    expect(responseDecoder!.userInfo.keys.first?.rawValue).to(equal("test"))
                }

                it("can handle custom coder") {
                    let customRequest = Old_Patch("path", "to", "endpoint", from: service, bodyEncoder: JSONEncoder(), responseDecoder: JSONDecoder())

                    let bodyEncoder = customRequest.content?.bodyEncoder as? JSONEncoder
                    expect(bodyEncoder).neverTo(beNil())
                    expect(bodyEncoder?.userInfo).to(beEmpty())

                    let responseDecoder = customRequest.content?.responseDecoder as? JSONDecoder
                    expect(responseDecoder).neverTo(beNil())
                    expect(responseDecoder?.userInfo).to(beEmpty())
                }
            }
            
            context("as DELETE") {
                let deleteRequest = Old_Delete("path", "to", "endpoint", from: service)
                let content = Content(path: path, service: service, method: .delete, bodyEncoder: JSONEncoder(), responseDecoder: JSONDecoder())
                
                it("has proper request content") {
                    expect(deleteRequest.content).neverTo(beNil())
                    
                    let requestContent = deleteRequest.content
                    expect(requestContent?.path).to(equal(content.path))
                    expect(requestContent?.service.baseURL).to(equal(content.service.baseURL))
                    expect(requestContent?.method).to(equal(content.method))
                }

                it("has default coder inherited from service") {
                    let bodyEncoder = deleteRequest.content?.bodyEncoder as? JSONEncoder
                    expect(bodyEncoder).neverTo(beNil())
                    expect(bodyEncoder!.userInfo.keys.first?.rawValue).to(equal("test"))

                    let responseDecoder = deleteRequest.content?.responseDecoder as? JSONDecoder
                    expect(responseDecoder).neverTo(beNil())
                    expect(responseDecoder!.userInfo.keys.first?.rawValue).to(equal("test"))
                }

                it("can handle custom coder") {
                    let customRequest = Old_Delete("path", "to", "endpoint", from: service, bodyEncoder: JSONEncoder(), responseDecoder: JSONDecoder())

                    let bodyEncoder = customRequest.content?.bodyEncoder as? JSONEncoder
                    expect(bodyEncoder).neverTo(beNil())
                    expect(bodyEncoder?.userInfo).to(beEmpty())

                    let responseDecoder = customRequest.content?.responseDecoder as? JSONDecoder
                    expect(responseDecoder).neverTo(beNil())
                    expect(responseDecoder?.userInfo).to(beEmpty())
                }
            }
        }
    }
}
