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
    
    public func send<RequestType: Request>(request: RequestType) -> AnyPublisher<RequestType.Response, ResponseError<RequestType.ResponseError>> {
        run(for: request)
    }
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func send<RequestType: Request>(request: RequestType) async -> (RequestType.Response?, ResponseError<RequestType.ResponseError>?) {
        await withCheckedContinuation { continuation in
            send(request: request) { response, error in
                continuation.resume(returning: (response, error))
            }
        }
    }
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func trySend<RequestType: Request>(request: RequestType) async throws -> RequestType.Response {
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
    
    public func send<RequestType: Request>(request: RequestType, result: @escaping (RequestType.Response?, ResponseError<RequestType.ResponseError>?) -> Void) {
        run(for: request)
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

private extension Session {
    func run<RequestType: Request>(for request: RequestType) -> AnyPublisher<RequestType.Response, ResponseError<RequestType.ResponseError>> {
        do {
            guard let content = request.content
            else { throw RequestError.requestContentIsNotSet }
            
            let urlRequest = try request.urlRequest()
            
#if DEBUG
            if debugLogging {
                let body = String(describing: String(data: urlRequest.httpBody ?? Data(), encoding: .utf8))
                let trimmedBody = body.count > 600 ? body.prefix(300) + "\n[...]\n" + body.suffix(300) : body
                
                print("\n-> \(content.method.rawValue.uppercased()) \(urlRequest.url!)")
                print("-> Header: \(String(describing: urlRequest.allHTTPHeaderFields))")
                print("-> Body: \(trimmedBody)\n")
            }
#endif
            
            return session
                .dataTaskPublisher(for: urlRequest)
                .tryMap { [weak self] result in
                    guard let content = request.content
                    else { throw RequestError.requestContentIsNotSet }
                    
                    guard let httpResponse = result.response as? HTTPURLResponse
                    else { throw ResponseError<Any>.unsupportedResponseType(result.response) }
                    
#if DEBUG
                    if let self = self, self.debugLogging {
                        let body = String(describing: String(data: result.data, encoding: .utf8))
                        let trimmedBody = body.count > 600 ? String(body.prefix(300) + "\n[...]\n" + body.suffix(300)) : body
                        
                        print("\n-> Response: \(content.path)")
                        print("-> Status: \(httpResponse.statusCode)")
                        print("-> Body: \(trimmedBody)")
                    }
#endif
                    
                    guard (200..<300).contains(httpResponse.statusCode) else {
                        if RequestType.ResponseError.self == Empty.self {
                            throw ResponseError<RequestType.ResponseError>.noResponse
                        } else if let errorDescription = try? content.responseDecoder.decode(RequestType.ResponseError.self, from: result.data)  {
                            throw ResponseError<RequestType.ResponseError>.badResponse(httpResponse, errorDescription)
                        } else {
                            throw ResponseError<RequestType.ResponseError>.badResponse(httpResponse, .none)
                        }
                    }

                    if RequestType.Response.self == Empty.self {
                        return Empty() as! RequestType.Response
                    } else {
                        return try content.responseDecoder.decode(RequestType.Response.self, from: result.data)
                    }
                }
                .mapError({ error in
#if DEBUG
                    if self.debugLogging {
                        print("-> Error: \(error)")
                    }
#endif
                    return error
                })
                .mapError(ResponseError.init)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: ResponseError(error))
                .eraseToAnyPublisher()
        }
    }
}
