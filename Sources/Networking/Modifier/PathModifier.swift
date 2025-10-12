//
//  PathModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 20.09.2025.
//

struct PathModifier<Content>: RequestModifier where Content: Request {
    let path: String
    
    init(_ path: String) {
        self.path = path
    }
    
    init(_ path: [String]) {
        self.path = path.joined(separator: "/")
    }
    
    func body(content: Content) -> some Request {
        content.configuration(\.path, value: path)
    }
}

public extension Request {
    func path(_ path: String) -> some Request {
        modifier(PathModifier(path))
    }
    
    func path(_ path: String...) -> some Request {
        modifier(PathModifier(path))
    }
}
