//
//  RequestError.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 29.09.2025.
//

public enum RequestError: Error {
    case missingService
    case missingConfiguration
    case resolvingUrlComponentsFailed
}
