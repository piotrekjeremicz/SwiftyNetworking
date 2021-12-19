//
//  Error.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 19/12/2021.
//

import Foundation

public enum ResponseError<ErrorDescription>: Error {
    case noResponse
    case url(URLError)
    case decoding(DecodingError)
    case badResponse(HTTPURLResponse, ErrorDescription?)
    case unsupportedResponseType(URLResponse)
    case unknown
    
    init(_ error: Swift.Error) {
        switch error {
        case is URLError:
            self = .url(error as! URLError)
        case is DecodingError:
            self = .decoding(error as! DecodingError)
        default:
            self = error as? ResponseError ?? .unknown
        }
    }
}

