//
//  SessionSpec.swift
//  
//
//  Created by Piotrek on 11/07/2022.
//

import Quick
import Nimble
import Combine
import Foundation
@testable import Networking

final class SessionSpec: QuickSpec {
    override func spec() {
        describe("creating") {
            context("default session") {
                let session = Session()
                let service = MockService()
                let request = MockRequest(service: service)
                
                it("has default turned off logging") {
                    expect(session.debugLogging).to(equal(false))
                }
                
                it("run request and return clousure") {
                    session.send(request: request) { data, error in }
                }
                
                it("run request and return publisher") {
                    var cancelables = Set<AnyCancellable>()
                    
                    session.send(request: request)
                        .sink { data in } receiveValue: { error in }
                        .store(in: &cancelables)
                }
                
                it("run request as async task") {
                    Task {
                        let (data, error) = await session.send(request: request)
                    }
                }
                
                it("run request as throwable async task") {
                    Task {
                        do {
                            let data = try await session.trySend(request: request)
                        } catch {
                            
                        }
                    }
                }
            }
        }
    }
}
