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

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let keyValue = try container.decode([String: Value].self).first
        
        guard let key = keyValue?.key, let value = keyValue?.value else {
            throw DecodingError.dataCorruptedError(
              in: container,
              debugDescription: "Invalid key and value: \(String(describing: keyValue))"
            )
        }
        
        self = .init(key, value: value)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(dictionary)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.key == rhs.key && lhs.value.description == rhs.value.description
    }
}
