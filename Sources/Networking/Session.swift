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
    private var cancelables = Set<AnyCancellable>()
    
    public init(
        session: URLSession = URLSession(configuration: .default),
        debugLogging: Bool = false
    ) {
        self.session = session
        self.debugLogging = debugLogging
    }
    
    public func send<RequestType: Request>(request: RequestType) async -> (Response<RequestType.ResponseBody>?, ResponseError<RequestType.ResponseError>?) {
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
    
    public func trySend<RequestType: Request>(request: RequestType) async throws -> Response<RequestType.ResponseBody> {
		try await run(for: request)
    }
}

private extension Session {
	func run<RequestType: Request>(for request: RequestType) async throws -> Response<RequestType.ResponseBody> {
		do {
#if DEBUG
			if debugLogging { print(request) }
#endif
			
			let urlRequest = try request.urlRequest()
			let result = try await session.data(for: urlRequest)
			let response = try Response<RequestType.ResponseBody>(result, from: request)
			
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
