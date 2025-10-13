//
//  User.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 13.10.2025.
//

nonisolated struct User: Codable {
    let id:  Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let gender: String
    let image: String
}
