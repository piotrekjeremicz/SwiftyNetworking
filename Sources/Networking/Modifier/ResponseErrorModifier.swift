//
//  ResponseErrorModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 03.10.2025.
//

public extension Request {
    func responseError<E: Codable>(_ type: E.Type) -> some Request {
        let configuration = makeRequest()
        configuration[keyPath: \.responseErrorType] = type
        
        return OverrideRequest<Self, Self.ResponseBody, E>(content: self, configuration: configuration)
    }
}
