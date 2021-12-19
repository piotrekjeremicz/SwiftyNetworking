//
//  Api.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 19/12/2021.
//

import Combine
import Foundation

public final class Api {
    
    private let session: URLSession
    private var cancelables = Set<AnyCancellable>()
    
    public init(
        session: URLSession = URLSession(configuration: .default)
    ) {
        self.session = session
    }
    
    public func send<RequestType: Request>(request: RequestType, result: @escaping (RequestType.Response?, ResponseError<RequestType.ResponseError>?) -> Void) {
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
    
    public func send<RequestType: Request>(request: RequestType) -> AnyPublisher<RequestType.Response, ResponseError<RequestType.ResponseError>> {
        runSession(for: request)
    }
    
    public func send<RequestType: Request>(request: RequestType) async -> (RequestType.Response?, ResponseError<RequestType.ResponseError>?) {
        await withCheckedContinuation { continuation in
            send(request: request) { response, error in
                continuation.resume(returning: (response, error))
            }
        }
    }
}

private extension Api {
    func runSession<RequestType: Request>(for request: RequestType) -> AnyPublisher<RequestType.Response, ResponseError<RequestType.ResponseError>> {
        session
            .dataTaskPublisher(for: request.urlRequest())
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse
                else { throw ResponseError<RequestType.ResponseError>.unsupportedResponseType(result.response) }
                
                guard (200..<300).contains(httpResponse.statusCode) else {
                    let errorDescription = try? request.responseDecoder.decode(RequestType.ResponseError.self, from: result.data)
                    throw ResponseError<RequestType.ResponseError>.badResponse(httpResponse, errorDescription)
                }
                
                return try request.responseDecoder.decode(RequestType.Response.self, from: result.data)
            }
            .mapError(ResponseError.init)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
