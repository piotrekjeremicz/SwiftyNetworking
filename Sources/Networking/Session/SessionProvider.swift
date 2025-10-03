//
//  SessionProvider.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 29.09.2025.
//

protocol SessionProvider {
    func run<R: Request>(_ request: R) async throws -> R.ResponseBody
}
