//
//  URLSessionProvider.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 29.09.2025.
//

#if canImport(Foundation)
import Foundation

final class URLSessionProvider: SessionProvider {
    func run<R: Request>(_ request: R) async throws -> R.ResponseBody {
        let urlRequest = try createURLRequest(from: request)
        return "" as! R.ResponseBody
    }
    
    func createURLRequest<R>(from request: R) throws -> URLRequest where R: Request {
        guard let configuration = request.configuration
        else { throw RequestError.missingConfiguration }
        
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



