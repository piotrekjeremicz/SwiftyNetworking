//
//  KeyValueBuilder.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 26.09.2025.
//


@resultBuilder
public struct KeyValueBuilder {
    public static func buildBlock(_ components: any KeyValuePair...) -> [any KeyValuePair] {
        components
    }

    public static func buildOptional(_ component: [any KeyValuePair]?) -> [any KeyValuePair] {
        component ?? []
    }

    public static func buildArray(_ components: [[any KeyValuePair]]) -> [any KeyValuePair] {
        components.flatMap { $0 }
    }

    public static func buildEither(first component: [any KeyValuePair]) -> [any KeyValuePair] {
        component
    }

    public static func buildEither(second component: [any KeyValuePair]) -> [any KeyValuePair] {
        component
    }
}
