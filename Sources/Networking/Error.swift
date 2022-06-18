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
    case request(RequestError)
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
        case is RequestError:
            self = .request(error as! RequestError)
        default:
            self = error as? ResponseError ?? .unknown(error)
        }
    }
}

public enum RequestError: Error {
    case requestContentIsNotSet
    case resolvingUrlComponentsFailed
}
