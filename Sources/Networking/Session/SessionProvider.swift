//
//  SessionProvider.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 29.09.2025.
//

protocol SessionProvider: Sendable {
    func run<R: Request>(_ request: R) async throws -> Response<R.ResponseBody>
}
