//
//  BodyModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 21.09.2025.
//

import Foundation

public struct BodyModifier<Content>: RequestModifier where Content: Request {
    let body: Data
    
    public func body(content: Content) -> some Request {
        content.configuration(\.body, value: body)
    }
}

public extension Request {
    func body(_ data: Data?) -> some Request {
        modifier(BodyModifier(body: data ?? Data()))
    }
    
    func body(@KeyValueBuilder _ items: () -> [any KeyValuePair]) -> some Request {
        modifier(
            BodyModifier(
                body: (try? JSONEncoder().encode(KeyValueGroup(items))) ?? Data()
            )
        )
    }
    
    func body(_ contentType: ContentType, @KeyValueBuilder _ items: () -> [any KeyValuePair]) -> some Request {
        modifier(
            BodyModifier(
                body: (try? JSONEncoder().encode(KeyValueGroup(items))) ?? Data()
            )
        )
        .headers {
            contentType
        }
    }
    
    func body(encoding: String.Encoding = .utf8, _ string: String) -> some Request {
        modifier(
            BodyModifier(
                body: string.data(using: encoding) ?? Data()
            )
        )
        .headers {
            ContentType.plainText
        }
    }
}
