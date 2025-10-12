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
        let resolvedRequest = await resolve(request)

        await registry.register(request, with: sessionId)
        defer { Task { await registry.remove(sessionId) } }
        
        let configuration = resolvedRequest.resolveConfiguration()
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
        urlRequest.httpMethod = configuration.method.rawValue
        urlRequest.addValue(id.uuidString, forHTTPHeaderField: "X-Request-ID")
        configuration.headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        if let body = configuration.body {
            urlRequest.httpBody = body
        }
        
        return urlRequest
    }
}

extension URLSessionProvider {
    func cancel(requests: Session.RequestType) async {
        switch requests {
        case .allTasks:
            session.invalidateAndCancel()
            
        case let .every(type):
            let requests = await registry.get(by: type)
            for task in await session.allTasks {
                if let request = task.originalRequest,
                   let id = request.value(forHTTPHeaderField: "X-Request-ID"),
                   requests.contains(where: { $0.id.uuidString == id })
                {
                    task.cancel()
                    await registry.remove(id)
                }
            }
            
        case let .only(id):
            for task in await session.allTasks {
                if let request = task.originalRequest,
                    let requestId = request.value(forHTTPHeaderField: "X-Request-ID"),
                    id.uuidString == requestId
                {
                    task.cancel()
                    await registry.remove(id.uuidString)
                }
            }
        }
    }
}

extension URLSessionProvider {
    func resolve<R>(_ request: R) async -> any Request where R: Request {
        var anyRequest: any Request = request
        let interceptors = request.resolveConfiguration().requestInterceptors
        
        for interceptor in interceptors {
            anyRequest = await interceptor(anyRequest)
        }
        
        return anyRequest
    }
}

private extension URLSessionProvider {
    func describe<R>(_ request: R, by urlRequest: URLRequest, for id: UUID) -> String where R: Request {
        var array = [String]()
        array.append("• Request<\(id)>: " + String(describing: type(of: request)))
        array.append(urlRequest.requestDescription)
        
        return array.joined(separator: "\n") + "\n"
    }
    
    func describe<R>(_ result: (data: Data, urlResponse: URLResponse), from request: R, for id: UUID) -> String where R: Request {
        var array = [String]()
        array.append("• Response<\(id)>: " + String(describing: type(of: request)))
        array.append(result.urlResponse.responseDescription)
        
        let bodyString: String? = {
            if let utf8 = String(data: result.data, encoding: .utf8) {
                return utf8
            }
            // Fall back to ISO-8859-1 which is common in HTTP contexts
            if let latin1 = String(data: result.data, encoding: .isoLatin1) {
                return latin1
            }
            // As a last resort, indicate binary body with byte count
            return "<\(result.data.count) bytes binary body>"
        }()
        
        array.append((bodyString ?? ""))
        
        return array.joined(separator: "\n") + "\n"
    }
}
#endif


