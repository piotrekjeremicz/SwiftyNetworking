//
//  KeyValueBuilder.swift
//  
//
//  Created by Piotrek Jeremicz on 08/04/2023.
//

import Foundation

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
