//
//  KeyValuePair 2.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 26.09.2025.
//

internal enum KeyValueCodingKey: String, CodingKey {
    case key, value
}

public protocol KeyValuePair: ValueBasicType {
    associatedtype Value: ValueBasicType
    
    var key: String { get }
    var value: Value { get }
    
    var dictionary: [String: Value] { get }
    
    init(_ key: String, value: Value)
}

extension KeyValuePair {
    public var description: String { "\(key): \(value)"}
    public var dictionary: [String: Value] { [key: value] }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(dictionary)
    }
}
