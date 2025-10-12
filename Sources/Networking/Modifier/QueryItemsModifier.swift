//
//  QueryItemsModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 21.09.2025.
//

import Foundation

struct QueryItemsModifier<Content>: RequestModifier where Content: Request {
    let override: Bool
    let queryItems: [URLQueryItem]
    
    func body(content: Content) -> some Request {
        var items = content.configuration?.queryItems ?? []
        
        if override {
            items = queryItems
        } else {
            items.append(contentsOf: queryItems)
        }
        
        return content.configuration(\.queryItems, value: items)
    }
}

public extension Request {
    func queryItems(override: Bool = false, _ items: [URLQueryItem]) -> some Request {
        modifier(QueryItemsModifier(override: override, queryItems: items))
    }

    func queryItems(override: Bool = false, _ items: [String: String]) -> some Request {
        modifier(
            QueryItemsModifier(
                override: override,
                queryItems: items.map {
                    URLQueryItem(
                        name: $0.key,
                        value: $0.value
                    )
                }
            )
        )
    }
    
    func queryItems(override: Bool = false, @KeyValueBuilder _ items: () -> [any KeyValuePair]) -> some Request {
        modifier(
            QueryItemsModifier(
                override: override,
                queryItems: items().map {
                    URLQueryItem(
                        name: $0.key,
                        value: $0.value.description
                    )
                }
            )
        )
    }
}
