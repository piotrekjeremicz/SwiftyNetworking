//
//  ModifiedRequest.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 20.09.2025.
//

public struct ModifiedRequest<Content, Modifier> where Content: Request, Modifier: RequestModifier, Content == Modifier.Content {
    public typealias Body = Modifier.Body
    
    public var content: Content
    public var modifier: Modifier

    private var modifiedBody: Body
    
    public init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
        
        modifiedBody = modifier.body(content: content)
    }
}

extension ModifiedRequest: Request {
    public var body: Self.Body { modifiedBody }
    
    public var configuration: ConfigurationValues? {
        get { modifiedBody.configuration }
        set { modifiedBody.configuration = newValue }
    }
}
