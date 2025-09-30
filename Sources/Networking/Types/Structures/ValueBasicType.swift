//
//  ValueBasicType.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 26.09.2025.
//

nonisolated public protocol ValueBasicType: Encodable, CustomStringConvertible { }

extension Swift.Int: ValueBasicType {}

extension Swift.Bool: ValueBasicType {}

extension Swift.Double: ValueBasicType {}

extension Swift.String: ValueBasicType {}

extension Swift.Array: ValueBasicType where Element: ValueBasicType {}

extension Swift.Optional: ValueBasicType, @retroactive CustomStringConvertible where Wrapped: ValueBasicType {
    public var description: String {
        switch self {
        case .none:
            "null"
        case let .some(wrapped):
            wrapped.description
        }
    }
}
