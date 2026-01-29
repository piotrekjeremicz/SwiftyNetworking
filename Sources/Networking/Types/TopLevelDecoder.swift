//
//  TopLevelDecoder.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 10.10.2025.
//

import Foundation

public protocol TopLevelDecoder: Sendable {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: TopLevelDecoder { }
