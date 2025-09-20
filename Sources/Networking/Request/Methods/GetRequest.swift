//
//  GetRequest.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 20.09.2025.
//

public struct Get: Request {
    let path: String
    
    public init(_ path: String) {
        self.path = path
    }
    
    public init(_ path: String...) {
        self.path = path.joined(separator: "/")
    }
    
    public var body: some Request {
        EmptyRequest()
            .method(.get)
            .path(path)
    }
}
