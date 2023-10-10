//
//  Session.swift
//  
//
//  Created by Piotrek Jeremicz on 09/04/2023.
//

import Foundation

public final class Session {
    
    private let registry: Registry
    private let session: URLSession
    
    private let configuration: Configuration

    public init(
        session: URLSession = URLSession(configuration: .default),
        configuration: Configuration = .init()
    ) {
        self.session = session
        self.registry = Registry()
        self.configuration = configuration
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

            if configuration.logging { resolvedRequest.configuration?.service.logger.info("\(resolvedRequest.description)") }

            let urlRequest = try resolvedRequest.urlRequest()
            await registry.register(resolvedRequest)


            let result = try await session.data(for: urlRequest)
            let response = try request.builder.resolve(result: result, request: resolvedRequest)
            await registry.remove(resolvedRequest)

            let resolvedResponse = resolvedRequest.configuration?.service.afterEach(response) ?? response
            
            if configuration.logging { resolvedRequest.configuration?.service.logger.info("\(resolvedResponse.description)") }

            return resolvedResponse
        } catch {
            if configuration.logging { request.body.resolve.configuration?.service.logger.error("• Error: \(String(describing: type(of: request)))\n\(error)\n") }

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
            let requests = await registry.get(by: type)
            for task in await session.allTasks {
                if let request = task.originalRequest, let id = request.value(forHTTPHeaderField: "X-Request-ID"), requests.contains(where: { $0.id.uuidString == id }) {
                    task.cancel()
                    await registry.remove(id)
                }
            }

        case .only(let id):
            for task in await session.allTasks {
                if let request = task.originalRequest, let requestId = request.value(forHTTPHeaderField: "X-Request-ID"), id.uuidString == requestId {
                    task.cancel()
                    await registry.remove(id.uuidString)
                }
            }
        }
    }
}
