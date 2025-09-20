//
//  PutRequest.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 20.09.2025.
//

public struct Put: Request {
    let path: String
    
    public init(_ path: String) {
        self.path = path
    }
    
    public init(_ path: String...) {
        self.path = path.joined(separator: "/")
    }
    
    public init(_ components: any CustomStringConvertible...) {
        self.path = components.map { $0.description }.joined(separator: "/")
    }
    
    public var body: some Request {
        EmptyRequest()
            .path(path)
            .method(.put)
    }
}
