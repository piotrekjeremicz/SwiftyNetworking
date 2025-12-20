//
//  AuthorizeModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 11.10.2025.
//

public extension Request {
    func authorize() -> some Request {
        beforeRequest { configuration in
            configuration.service?.authorizationProvider?.authorize(&configuration)
        }
    }
}
