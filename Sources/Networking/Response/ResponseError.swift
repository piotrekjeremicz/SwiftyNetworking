//
//  ResponseError.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 10.10.2025.
//

enum ResponseError<ResponseError>: Error where ResponseError: Codable & Sendable {
    case decodingFailed
    case missingService
    case unsupportedResponseType
    case interceptedResponseBodyTypeMismatch
    case serverError(Response<ResponseError>)
}
