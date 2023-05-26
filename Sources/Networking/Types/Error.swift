//
//  Error.swift
//  
//
//  Created by Piotrek on 18/06/2022.
//

import Foundation

public enum ResponseError<ErrorDescription>: Error {
    case noResponse
    case url(URLError)
    case decoding(DecodingError)
    case badResponse(HTTPURLResponse, ErrorDescription?)
    case unsupportedResponseType(URLResponse)
    case unknown(Swift.Error)
    
    public init(_ error: Swift.Error) {
        switch error {
        case is URLError:
            self = .url(error as! URLError)

        case is DecodingError:
            self = .decoding(error as! DecodingError)

        default:
            self = error as? ResponseError ?? .unknown(error)
        }
    }
    
    public var localizedDescription: String {
        description
    }
}

public enum RequestError: Error {
    case requestConfigurationIsNotSet
    case resolvingUrlComponentsFailed
}

extension ResponseError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .noResponse:
            return "• No Response"
        case .url(let error):
            return "• URL Error: " + error.localizedDescription
        case .decoding(let error):
            return "• Decoding Error: \n   - Description: " + error.localizedDescription + "\n   - Reason: " + (error.failureReason ?? "no reason")
        case .badResponse(let response, let error):
            return "• Response Error: \n   - Response: " + response.description + "\n   Error: " + error.debugDescription
        case .unsupportedResponseType(let response):
            return "• Unsuported Response Error: \n   - Response: " + response.description
        case .unknown(let error):
            return "• Unknown Error: " + error.localizedDescription
        }
    }
}
