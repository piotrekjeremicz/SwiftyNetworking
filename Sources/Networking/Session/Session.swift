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
    func send<R: Request>(_ request: R, completion: @escaping (Result<R.ResponseBody, Error>) -> Void) {
        Task {
            do {
                let response = try await provider.run(request)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func send<R: Request>(_ request: R) async -> Result<R.ResponseBody, Error> {
        do {
            let response = try await provider.run(request)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
    
    func trySend<R: Request>(_ request: R) async throws -> R.ResponseBody {
        try await provider.run(request)
    }
}

#if canImport(Combine)
import Combine

public extension Session {
    func send<R: Request>(_ request: R) -> AnyPublisher<R.ResponseBody, Error> {
        Deferred { [provider = self.provider] in
            Future<R.ResponseBody, Error> { promise in
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
