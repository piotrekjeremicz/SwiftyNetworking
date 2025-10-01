//
//  Session.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 29.09.2025.
//

public final class Session {
    let provider: SessionProvider
    
    init(provider: SessionProvider) {
        self.provider = provider
    }
}

public extension Session {
    func send<R: Request>(_ request: R, completion: @escaping (Result<String, Error>) -> Void) {
        Task {
            do {
                let response = try await provider.run(request)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func send<R: Request>(_ request: R) async -> Result<String, Error> {
        do {
            let response = try await provider.run(request)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
    
    func trySend<R: Request>(_ request: R) async throws -> String {
        try await provider.run(request)
    }
}

#if canImport(Combine)
import Combine

public extension Session {
    func send<R: Request>(_ request: R) -> AnyPublisher<String, Error> {
        Deferred { [provider = self.provider] in
            Future<String, Error> { promise in
                Task {
                    do {
                        let response = try await provider.run(request)
                        promise(.success(response))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
#endif
