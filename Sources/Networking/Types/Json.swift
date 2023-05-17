//
//  Json.swift
//  
//
//  Created by Piotrek Jeremicz on 30/12/2022.
//

import Foundation

public protocol JsonKey { }
extension Key: JsonKey { }

struct Group: JsonKey {
	let group: [any JsonKey]
	
	init(@JsonBuilder _ group: () -> [any JsonKey] ) {
		self.group = group()
	}
}

public struct Json {
	public let root: [any JsonKey]
	
	init(@JsonBuilder _ root: () -> [any JsonKey]) {
		self.root = root()
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
