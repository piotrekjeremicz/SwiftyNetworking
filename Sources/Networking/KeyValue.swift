//
//  File.swift
//  
//
//  Created by Piotrek Jeremicz on 23/12/2022.
//

import Foundation

enum KeyValueCodingKey: String, CodingKey {
	case key, value
}

public protocol ValueBasicType: Encodable, CustomStringConvertible, Equatable { }

extension Swift.Int: ValueBasicType { }
extension Swift.Bool: ValueBasicType { }
extension Swift.Double: ValueBasicType { }
extension Swift.String: ValueBasicType { }
extension Swift.Array: ValueBasicType where Element: ValueBasicType { }

extension ValueBasicType {
	public static func == (lhs: any ValueBasicType, rhs: any ValueBasicType) -> Bool {
		lhs.description == rhs.description
	}
}

public protocol KeyValueProvider: ValueBasicType {
    var key: String { get }
    var value: any ValueBasicType { get }
    var dictionary: [String: any ValueBasicType] { get }
}

extension KeyValueProvider {
	public var description: String { "\(key): \(value.description)"}
    public var dictionary: [String: any ValueBasicType] { [key: value] }
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: KeyValueCodingKey.self)
		try container.encode(key, forKey: .key)
		try container.encode(value, forKey: .value)
	}
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.key == rhs.key && lhs.value.description == rhs.value.description
	}
}


public struct Key: KeyValueProvider {
    public let key: String
    public let value: any ValueBasicType

    public init(_ key: String, value: any ValueBasicType) {
        self.key = key
        self.value = value
    }
	
	public init(_ key: String, @JsonBuilder json: () -> [any JsonKey]) {
		self.key = key
		self.value = json() as? (any ValueBasicType) ?? Array<Key>() 
	}
}

public struct X_Api_Key: KeyValueProvider {
    public let key: String
    public let value: any ValueBasicType

    public init(_ value: String) {
        self.key = "X-Api-Key"
        self.value = value
    }
}

public struct Authorization: KeyValueProvider {
    public let key: String
    public let value: any ValueBasicType
    
    public init(_ value: String) {
        self.key = "Authorization"
        self.value = value
    }
}

@resultBuilder
public struct KeyValueBuilder {
    public static func buildBlock(_ components: any KeyValueProvider...) -> [any KeyValueProvider] {
        components
    }

    public static func buildEither(first component: [any KeyValueProvider]) -> [any KeyValueProvider] {
        component
    }

    public static func buildEither(second component: [any KeyValueProvider]) -> [any KeyValueProvider] {
        component
    }

    public static func buildArray(_ components: [[any KeyValueProvider]]) -> [any KeyValueProvider] {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [any KeyValueProvider]?) -> [any KeyValueProvider] {
        component ?? []
    }
}
