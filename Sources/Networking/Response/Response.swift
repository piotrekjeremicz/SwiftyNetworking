//
//  File.swift
//  
//
//  Created by Piotrek Jeremicz on 07/01/2023.
//

import Foundation

public struct Response<Body: Codable> {
    public let body: Body

    public let statusCode: Int
    public let headers: [AnyHashable: Any]
    public let originalResponse: URLResponse

    private let requestId: UUID
    private let requestName: String
    private let dataEncoder: any DataEncoder

    init<R: Request>(_ result: (data: Data, response: URLResponse), from request: R) throws {
        guard let configuration = request.configuration
        else { throw RequestError.requestConfigurationIsNotSet }

        guard let httpResponse = result.response as? HTTPURLResponse
        else { throw ResponseError<Empty>.unsupportedResponseType(result.response) }

        self.originalResponse = httpResponse
        self.statusCode = httpResponse.statusCode
        self.headers = httpResponse.allHeaderFields
        
        self.requestId = request.id
        self.requestName = String(describing: type(of: request))
        self.dataEncoder = configuration.responseBodyEncoder

        guard (200..<400).contains(statusCode) else {
            if let errorDescription = try? configuration.responseBodyDecoder.decode(R.ResponseError.self, from: result.data)  {
                throw ResponseError<R.ResponseError>.badResponse(httpResponse, (errorDescription as? R.ResponseError))
            } else {
                throw ResponseError<R.ResponseError>.badResponse(httpResponse, .none)
            }
        }

        if Body.self == Empty.self {
            self.body = Empty() as! Body
        } else if Body.self == Data.self {
            self.body = result.data as! Body
        } else {
            self.body = try configuration.responseBodyDecoder.decode(Body.self, from: result.data)
        }
    }
}

extension Response: CustomStringConvertible {
    public var description: String {
        var array = [String]()
        array.append("• Response<\(requestId)>: " + requestName)
        array.append("HTTP/1.1 \(statusCode) " + HTTPURLResponse.localizedString(forStatusCode: statusCode).capitalized)
        array.append(contentsOf: headers.map({ "\($0.key): \($0.value)" }))

        if let data = try? dataEncoder.encode(body), let string = String(data: data, encoding: .utf8) {
            array.append("")
            array.append(string)
        }

        return array.joined(separator: "\n") + "\n"
    }
}
