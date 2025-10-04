//
//  Service.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 28.09.2025.
//

import OSLog

public protocol Service: Sendable {
    var baseURL: String { get }
    var logger: Logger { get }
}

public extension Service {
    var logger: Logger { networkingLogger }
}
