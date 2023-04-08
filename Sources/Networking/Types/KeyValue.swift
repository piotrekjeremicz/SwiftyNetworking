//
//  File.swift
//  
//
//  Created by Piotrek Jeremicz on 23/12/2022.
//

import Foundation

internal enum KeyValueCodingKey: String, CodingKey {
	case key, value
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
