//
//  SessionTests.swift
//  SwiftyNetworking
//

import Testing
import Foundation
@testable import Networking

@Suite("Session RequestType Tests")
struct SessionRequestTypeTests {

    @Test("RequestType allTasks")
    func allTasks() {
        let type = Session.RequestType.allTasks
        switch type {
        case .allTasks:
            #expect(Bool(true))
        default:
            #expect(Bool(false))
        }
    }

    @Test("RequestType every with request type")
    func everyWithType() {
        let type = Session.RequestType.every(Get.self)
        switch type {
        case .every:
            #expect(Bool(true))
        default:
            #expect(Bool(false))
        }
    }

    @Test("RequestType only with UUID")
    func onlyWithUUID() {
        let uuid = UUID()
        let type = Session.RequestType.only(uuid)
        switch type {
        case .only(let id):
            #expect(id == uuid)
        default:
            #expect(Bool(false))
        }
    }
}

@Suite("Registry Tests")
struct RegistryTests {

    @Test("Registry registers and retrieves requests")
    func registerAndRetrieve() async {
        let registry = Registry()
        let service = MockService()
        let request = Get("test", from: service)
        let id = UUID()

        await registry.register(request, with: id)
        let ids = await registry.get(by: type(of: request))

        #expect(ids.contains(id))
    }

    @Test("Registry removes requests")
    func removeRequest() async {
        let registry = Registry()
        let service = MockService()
        let request = Get("test", from: service)
        let id = UUID()

        await registry.register(request, with: id)
        await registry.remove(id)
        let ids = await registry.get(by: type(of: request))

        #expect(!ids.contains(id))
    }

    @Test("Registry returns empty for unregistered type")
    func unregisteredType() async {
        let registry = Registry()
        let ids = await registry.get(by: Get.self)

        #expect(ids.isEmpty)
    }

    @Test("Registry handles multiple requests of same type")
    func multipleRequestsSameType() async {
        let registry = Registry()
        let service = MockService()
        let request1 = Get("test1", from: service)
        let request2 = Get("test2", from: service)
        let id1 = UUID()
        let id2 = UUID()

        await registry.register(request1, with: id1)
        await registry.register(request2, with: id2)
        let ids = await registry.get(by: Get.self)

        #expect(ids.count == 2)
        #expect(ids.contains(id1))
        #expect(ids.contains(id2))
    }
}
