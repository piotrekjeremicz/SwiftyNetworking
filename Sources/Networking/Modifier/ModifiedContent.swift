//
//  ModifiedContent.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 20.09.2025.
//

public struct ModifiedContent<Content, Modifier> where Content: Request, Modifier: RequestModifier {
    public typealias Body = Modifier.Body
    
    public var content: Content
    public var modifier: Modifier

    public init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }
}

extension ModifiedContent: Request where Content == Modifier.Content {
    public var body: Self.Body {
        modifier.body(content: content)
    }
}
