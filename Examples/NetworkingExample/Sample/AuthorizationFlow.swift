//
//  AuthorizationFlow.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 12.10.2025.
//

import Networking

@Request
struct LoginRequest {
    let username: String
    let password: String
    
    var body: some Request {
        Post("auth", "login", from: DummyJsonService())
            .body(.json) {
                Key("username", value: username)
                Key("password", value: password)
                Key("expiresInMins", value: 30)
            }
            .responseBody(AuthorizedUser.self)
            .storeCredentials { authorizedUser, store in
                store.set(.accessToken, value: authorizedUser.accessToken)
            }
    }
}

@Request
struct AuthRequest {
    var body: some Request {
        Get("auth", "me", from: DummyJsonService())
            .responseBody(User.self)
            .authorize()
    }
}

func authorizationFlow(_ session: Session) async {
    let loginRequest = LoginRequest(username: "emilys", password: "emilyspass")
    await session.send(loginRequest)
    
    let authRequest = AuthRequest()
    await session.send(authRequest)
}
