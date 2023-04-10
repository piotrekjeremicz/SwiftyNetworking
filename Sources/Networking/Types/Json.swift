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
}
