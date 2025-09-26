//
//  ValueBasicType.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 26.09.2025.
//

nonisolated public protocol ValueBasicType: Codable, Equatable, CustomStringConvertible { }

extension Swift.Int: ValueBasicType { }
extension Swift.Bool: ValueBasicType { }
extension Swift.Double: ValueBasicType { }
extension Swift.String: ValueBasicType { }
extension Swift.Array: ValueBasicType where Element: ValueBasicType { }
