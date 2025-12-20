//
//  DummyAuthorizationProvider.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 12.10.2025.
//

import Networking

struct DummyAuthorizationProvider: AuthorizationProvider {
    let store: any AuthorizationStore = KeychainAuthorizationStore()

    func authorize(_ configuration: inout ConfigurationValues) {
        if let accessToken = store.get(.accessToken) {
            configuration.headers["Authorization"] = "Bearer \(accessToken)"
        }
    }
}
