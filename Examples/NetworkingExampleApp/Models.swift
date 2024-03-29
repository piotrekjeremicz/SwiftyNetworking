//
//  Models.swift
//  swifty-networking-sample-app
//
//  Created by Piotrek Jeremicz on 08/04/2023.
//

import Foundation

struct ExampleAuthResponseModel: Codable {
    let token: String
    let refreshToken: String
}

struct ExampleResponseModel: Codable {
    let id: UUID
    let title: String
    let description: String
}

struct ExampleErrorModel: Codable {
    let id: UUID
    let statusCode: Int
    let message: String
}
