//
//  URLSessionProvider.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 29.09.2025.
//

#if canImport(Foundation)
import Foundation

public actor URLSessionProvider: SessionProvider {
    private let session: URLSession = URLSession(configuration: .default)
    private let registry: Registry = .init()
    
    public func run<R: Request>(
        _ request: R
    ) async throws -> R.ResponseBody where R.ResponseBody: Decodable & Sendable {
        await registry.register(request)
        defer { Task { await registry.remove(request) } }
        
        let configuration = request.resolveConfiguration()
        
        let (data, urlResponse) = try await session.data(for: urlRequest)
        await registry.remove(request)
        
        let decoder = JSONDecoder()
        if let body = try? decoder.decode(R.ResponseBody.self, from: data) {
            return body
        }
        
        if let errorBody = try? decoder.decode(R.ResponseError.self, from: data) {
            throw ResponseError.serverError(errorBody)
        }
        
        throw ResponseError.decodingFailed
    }
    
    func createURLRequest<R>(from request: R) throws -> URLRequest where R: Request {
        let configuration = request.makeRequest()
        
        guard let service = configuration[keyPath: \.service]
        else { throw RequestError.missingService }
        
        guard var urlComponents = URLComponents(string: service.baseURL)
        else { throw RequestError.resolvingUrlComponentsFailed }
        
        urlComponents.path = configuration[keyPath: \.path]
        urlComponents.queryItems = configuration[keyPath: \.queryItems]
        
        guard let url = urlComponents.url
        else { throw RequestError.resolvingUrlComponentsFailed }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = configuration[keyPath: \.method].rawValue
        urlRequest.addValue(configuration.id.uuidString, forHTTPHeaderField: "X-Request-ID")
        configuration[keyPath: \.headers].forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        if let body = configuration[keyPath: \.body] {
            urlRequest.httpBody = body
        }
        
        return urlRequest
    }
}
#endif



enum ResponseError: Error {
    case decodingFailed
    case serverError(Any)
}
