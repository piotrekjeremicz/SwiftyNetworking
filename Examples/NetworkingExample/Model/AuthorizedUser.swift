//
//  AuthorizedUser.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 12.10.2025.
//

nonisolated struct AuthorizedUser: Codable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let gender: String
    let image: String
    let accessToken: String
    let refreshToken: String
}
