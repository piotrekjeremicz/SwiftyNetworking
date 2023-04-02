//
//  Session.swift
//  
//
//  Created by Piotrek on 19/06/2022.
//

import Combine
import Foundation

public final class Session {
    public static let manager = Session()
    
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
    
    public func send<RequestType: Old_Request>(request: RequestType) async -> (Response<RequestType.ResponseBody>?, ResponseError<RequestType.ResponseError>?) {
		do {
			let response = try await run(for: request)
			return (response, nil)
		} catch {
			if let error = error as? ResponseError<RequestType.ResponseError> {
				return (nil, error)
			} else {
				return (nil, .unknown(error))
			}
			
		}
    }
    
    public func trySend<RequestType: Old_Request>(request: RequestType) async throws -> Response<RequestType.ResponseBody> {
		try await run(for: request)
    }
    
    public func cancel(requests: RequestType) async {
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

extension Session {
    public enum RequestType {
        case allTasks
        case every(_ type: any Old_Request.Type)
        case only(_ id: UUID)
    }
}

private extension Session {
	func run<RequestType: Old_Request>(for request: RequestType) async throws -> Response<RequestType.ResponseBody> {
		do {
#if DEBUG
			if debugLogging { print(request) }
#endif
			
			let urlRequest = try request.urlRequest()
            requestTypes.append((request.id, String(describing: request.self)))
            
			let result = try await session.data(for: urlRequest)
			let response = try Response<RequestType.ResponseBody>(result, from: request)
            requestTypes.removeAll(where: { $0.id == request.id })
			
#if DEBUG
			if debugLogging { print(response) }
#endif
			
			return response
		} catch {
#if DEBUG
			if debugLogging { print("• Error: " + String(describing: type(of: request)) + "\n\(error)"  + "\n") }
#endif
			throw error
		}
	}
}
