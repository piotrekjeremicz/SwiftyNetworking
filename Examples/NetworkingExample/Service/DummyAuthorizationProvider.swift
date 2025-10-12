//
//  DummyAuthorizationProvider.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 12.10.2025.
//

import Networking

struct DummyAuthorizationProvider: AuthorizationProvider {
    let store: any AuthorizationStore = KeychainAuthorizationStore()
    
    func authorize(_ request: any Request) -> any Request {
        if let accessToken = store.get(.accessToken) {
            request.headers {
                Authorization(bearer: accessToken)
            }
        } else {
            request
        }
    }
}
