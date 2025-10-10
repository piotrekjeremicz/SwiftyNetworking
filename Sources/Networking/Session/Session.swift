//
//  Session.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 29.09.2025.
//

public actor Session: Sendable {
    let provider: SessionProvider
    
    init(provider: SessionProvider) {
        self.provider = provider
    }
}

public extension Session {
    func send<R: Request>(_ request: R) async -> Result<Response<R.ResponseBody>, Error> {
        do {
            let response = try await provider.run(request)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
    
    func trySend<R: Request>(_ request: R) async throws -> Response<R.ResponseBody> {
        try await provider.run(request)
    }
}
