//
//  HeaderModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 21.09.2025.
//

public struct HeaderModifier<Content>: RequestModifier where Content: Request {
    let override: Bool
    let headers: [String: String]
    
    public func body(content: Content) -> some Request {
        var items = content.configuration[keyPath: \.?.headers] ?? [:]
        
        if override {
            items = headers
        } else {
            headers.forEach { items[$0.key] = $0.value }
        }

        return content.configuration(\.headers, value: items)
    }
}

public extension Request {
    func headers(override: Bool = false, _ fields: [String: String]) -> some Request {
        modifier(HeaderModifier(override: override, headers: fields))
    }
    
    func headers(override: Bool = false, @KeyValueBuilder _ fields: () -> [any KeyValuePair]) -> some Request {
        modifier(
            HeaderModifier(
                override: override,
                headers: Dictionary(
                    uniqueKeysWithValues: fields().map { ($0.key, $0.value.description) }
                )
            )
        )
    }
}
