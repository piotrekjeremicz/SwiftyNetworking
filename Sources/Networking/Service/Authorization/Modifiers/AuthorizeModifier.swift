//
//  AuthorizeModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 11.10.2025.
//

public extension Request {
    func authorize() -> some Request {
        beforeRequest { request in
            if let authorizationProvider = resolveConfiguration().service?.authorizationProvider {
                authorizationProvider.authorize(request)
            } else {
                request
            }
        }
    }
}
