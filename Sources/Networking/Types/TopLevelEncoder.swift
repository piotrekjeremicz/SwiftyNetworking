//
//  TopLevelEncoder.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 10.10.2025.
//

import Foundation

public protocol TopLevelEncoder {
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

extension JSONEncoder: TopLevelEncoder { }
