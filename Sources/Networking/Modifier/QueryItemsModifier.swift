//
//  QueryItemsModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 21.09.2025.
//

import Foundation

struct QueryItemsModifier<Content>: RequestModifier where Content: Request {
    let override: Bool
    let queryItems: [String: String]
    
    func body(content: Content) -> some Request {
        var items = content.configuration?.queryItems ?? [:]

        if override {
            items = queryItems
        } else {
            queryItems.forEach { items[$0.key] = $0.value }
        }
        
        return content.configuration(\.queryItems, value: items)
    }
}

public extension Request {
    func queryItems(override: Bool = false, _ items: [String: String]) -> some Request {
        modifier(QueryItemsModifier(override: override, queryItems: items))
    }

    func queryItems(override: Bool = false, @KeyValueBuilder _ items: () -> [any KeyValuePair]) -> some Request {
        modifier(
            QueryItemsModifier(
                override: override,
                queryItems: Dictionary(
                    uniqueKeysWithValues: items().map {
                        ($0.key, $0.value.description)
                    }
                )
            )
        )
    }
}
