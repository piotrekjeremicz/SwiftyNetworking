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
    ) async throws -> Response<R.ResponseBody> {
        let sessionId = UUID()

        await registry.register(request, with: sessionId)
        defer { Task { await registry.remove(sessionId) } }
        
        let configuration = request.resolveConfiguration()
        let urlRequest = try createURLRequest(from: configuration, for: sessionId)
        configuration.service?.logger?.info("\(self.describe(request, by: urlRequest, for: sessionId))")

        let result = try await session.data(for: urlRequest)
        configuration.service?.logger?.info("\(self.describe(result, from: request, for: sessionId))")
        
        return try ResponseBuilder.build(result, from: configuration, request: request)
    }
    
    func createURLRequest(from configuration: ConfigurationValues, for id: UUID) throws -> URLRequest {
        guard let service = configuration.service
        else { throw RequestError.missingService }
        
        guard var urlComponents = URLComponents(string: service.baseURL)
        else { throw RequestError.resolvingUrlComponentsFailed }
        
        urlComponents.path = "/" + configuration.path
        urlComponents.queryItems = configuration.queryItems
        
        guard let url = urlComponents.url
        else { throw RequestError.resolvingUrlComponentsFailed }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(configuration.id.uuidString, forHTTPHeaderField: "X-Request-ID")
        urlRequest.httpMethod = configuration.method.rawValue
        configuration.headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        if let body = configuration.body {
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
