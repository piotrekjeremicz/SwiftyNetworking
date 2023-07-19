//
//  Session.swift
//  
//
//  Created by Piotrek Jeremicz on 09/04/2023.
//

import Foundation

public final class Session {
    
    public let debugLogging: Bool

    private let session: URLSession
    private var requestTypes: [(id: UUID, type: String)] = []

    public init(
        session: URLSession = URLSession(configuration: .default),
        debugLogging: Bool = false
    ) {
        self.session = session
        self.debugLogging = debugLogging
    }

    public func send<R: Request>(request: R) async -> (Response<R.ResponseBody>?, ResponseError<R.ResponseError>?) {
        do {
            let response = try await run(for: request)
            return (response, nil)
        } catch {
            return (nil, ResponseError<R.ResponseError>(error))
        }
    }

    public func trySend<R: Request>(request: R) async throws -> Response<R.ResponseBody> {
        try await run(for: request)
    }
}

private extension Session {
    func run<R: Request>(for request: R) async throws -> Response<R.ResponseBody> {
        do {
            let resolvedRequest = request.body.resolve
#if DEBUG
            if debugLogging { resolvedRequest.configuration?.service.logger.info("\(resolvedRequest.description)") }
#endif

            let urlRequest = try resolvedRequest.urlRequest()
            requestTypes.append((resolvedRequest.id, String(describing: resolvedRequest.self)))

            let result = try await session.data(for: urlRequest)
            let response = try request.builder.resolve(result: result, request: resolvedRequest)
            requestTypes.removeAll(where: { $0.id == resolvedRequest.id })

            let resolvedResponse = request.configuration?.service.afterEach(response) ?? response
            
#if DEBUG
            if debugLogging { resolvedRequest.configuration?.service.logger.info("\(resolvedResponse.description)") }
#endif

            return resolvedResponse
        } catch {
#if DEBUG
            if debugLogging { request.configuration?.service.logger.error("• Error: \(String(describing: type(of: request)))\n\(error)\n") }
#endif
            throw error
        }
    }
}

public extension Session {
    enum RequestType {
        case allTasks
        case every(_ type: any Request.Type)
        case only(_ id: UUID)
    }

    func cancel(requests: RequestType) async {
        switch requests {
        case .allTasks:
            session.invalidateAndCancel()

        case .every(let type):
            let requests = requestTypes.filter({ $0.type == String(describing: type) })
            await session.allTasks.forEach({ task in
                if let request = task.originalRequest, let id = request.value(forHTTPHeaderField: "X-Request-ID"), requests.contains(where: { $0.id.uuidString == id }) {
                    task.cancel()
                    requestTypes.removeAll(where: { $0.id.uuidString == id })
                }
            })

        case .only(let id):
            await session.allTasks.forEach({ task in
                if let request = task.originalRequest, let requestId = request.value(forHTTPHeaderField: "X-Request-ID"), id.uuidString == requestId {
                    task.cancel()
                    requestTypes.removeAll(where: { $0.id.uuidString == id.uuidString })
                }
            })
        }
    }
}
