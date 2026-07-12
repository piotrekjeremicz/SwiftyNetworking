//
//  Empty.swift
//  SwiftyNetworking
//

import Foundation

public struct Empty: Codable, Sendable {
    public init() {}

    public init(from decoder: any Decoder) throws {}

    public func encode(to encoder: any Encoder) throws {}
}
