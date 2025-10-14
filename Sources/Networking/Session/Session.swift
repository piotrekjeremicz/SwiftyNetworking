//
//  Session.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 29.09.2025.
//

import Foundation

public actor Session: Sendable {
    let provider: SessionProvider
    
    init(provider: SessionProvider) {
        self.provider = provider
    }
}

public extension Session {
    @discardableResult
    func send<R: Request>(_ request: R) async -> Result<Response<R.ResponseBody>, Error> {
        do {
            let response = try await provider.run(request)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
    
    @discardableResult
    func trySend<R: Request>(_ request: R) async throws -> Response<R.ResponseBody> {
        try await provider.run(request)
    }
}

public extension Session {
    func cancel(_ type: RequestType) async {
        await provider.cancel(requests: type)
    }
}

public extension Session {
    enum RequestType: Sendable {
        case allTasks
        case every(_ type: any Request.Type)
        case only(_ id: UUID)
    }
}
