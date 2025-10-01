//
//  QueryItemsModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 21.09.2025.
//

import Foundation

public struct QueryItemsModifier<Content>: RequestModifier where Content: Request {
    let queryItems: [URLQueryItem]
    
    public func body(content: Content) -> some Request {
        content.configuration(\.queryItems, value: queryItems)
    }
}

public extension Request {
    func queryItems(_ items: [URLQueryItem]) -> some Request {
        modifier(QueryItemsModifier(queryItems: items))
    }

    func queryItems(_ items: [String: String]) -> some Request {
        modifier(
            QueryItemsModifier(
                queryItems: items.map {
                    URLQueryItem(
                        name: $0.key,
                        value: $0.value
                    )
                }
            )
        )
    }
    
    func queryItems(@KeyValueBuilder _ items: () -> [any KeyValuePair]) -> some Request {
        modifier(
            QueryItemsModifier(
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
