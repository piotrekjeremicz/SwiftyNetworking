//
//  Json.swift
//  
//
//  Created by Piotrek Jeremicz on 30/12/2022.
//

import Foundation

public protocol JsonKey: Codable { }
extension Key: JsonKey { }

public struct Group: JsonKey {
	let group: [any JsonKey]
	
	public init(@JsonBuilder _ group: () -> [any JsonKey] ) {
		self.group = group()
	}
    
    public init(from decoder: Decoder) throws {
//        var container = try decoder.unkeyedContainer()
//        let keyValues = try container.decode([KeyValueProvider].self)
        
        self = .init({ })
    }
    
    public func encode(to encoder: Encoder) throws {
//        var container = try encoder.unkeyedContainer()
//        try container.encode(group)
    }
}

public struct Json {
	public let root: Group
	
	public init(@JsonBuilder _ root: () -> [any JsonKey]) {
		self.root = Group(root)
	}
}

@resultBuilder
public struct JsonBuilder {
    public static func buildBlock(_ components: any JsonKey...) -> [any JsonKey] {
        components
    }

    public static func buildEither(first component: [any JsonKey]) -> [any JsonKey] {
        component
    }

    public static func buildEither(second component: [any JsonKey]) -> [any JsonKey] {
        component
    }

    public static func buildArray(_ components: [[any JsonKey]]) -> [any JsonKey] {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [any JsonKey]?) -> [any JsonKey] {
        component ?? []
    }
}
