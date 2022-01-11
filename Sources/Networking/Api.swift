//
//  Api.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 19/12/2021.
//

import Combine
import Foundation

public final class Api {
    
    static let manager = Api()
    
    private let session: URLSession
    private var cancelables = Set<AnyCancellable>()
    
    public init(
        session: URLSession = URLSession(configuration: .default)
    ) {
        self.session = session
    }
    
    func send<RequestType: Request>(request: RequestType) -> AnyPublisher<RequestType.Response, ResponseError<RequestType.ResponseError>> {
        runSession(for: request)
    }
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func send<RequestType: Request>(request: RequestType) async -> (RequestType.Response?, ResponseError<RequestType.ResponseError>?) {
        await withCheckedContinuation { continuation in
            send(request: request) { response, error in
                continuation.resume(returning: (response, error))
            }
        }
    }
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func trySend<RequestType: Request>(request: RequestType) async throws -> RequestType.Response {
        try await withCheckedThrowingContinuation { continuation in
            send(request: request) { response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    guard let response = response else {
                        continuation.resume(throwing: ResponseError<Any>.noResponse)
                        return
                    }

                    continuation.resume(returning: response)
                }
            }
        }
    }
    
    func send<RequestType: Request>(request: RequestType, result: @escaping (RequestType.Response?, ResponseError<RequestType.ResponseError>?) -> Void) {
        runSession(for: request)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    result(nil, error)
                case .finished:
                    break
                }
            } receiveValue: { data in
                result(data, nil)
            }
            .store(in: &cancelables)
    }
}

private extension Api {
    func runSession<RequestType: Request>(for request: RequestType) -> AnyPublisher<RequestType.Response, ResponseError<RequestType.ResponseError>> {
        session
            .dataTaskPublisher(for: request.urlRequest())
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse
                else { throw ResponseError<Any>.unsupportedResponseType(result.response) }
                
                guard (200..<300).contains(httpResponse.statusCode) else {
                    if let errorDescription = try? request.responseDecoder.decode(RequestType.ResponseError.self, from: result.data) {
                        throw ResponseError<Any>.badResponse(httpResponse, errorDescription)
                    } else {
                        throw ResponseError<Any>.badResponse(httpResponse, .none)
                    }
                }
                
                return try request.responseDecoder.decode(RequestType.Response.self, from: result.data)
            }
            .mapError(ResponseError.init)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
