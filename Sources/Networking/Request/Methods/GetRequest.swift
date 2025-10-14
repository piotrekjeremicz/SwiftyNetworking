//
//  GetRequest.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 20.09.2025.
//

public struct Get: Request {
    let path: String
    let service: Service
    
    public init(_ path: String, from service: Service) {
        self.path = path
        self.service = service
    }
    
    public init(_ path: String..., from service: Service) {
        self.path = path.joined(separator: "/")
        self.service = service
    }
    
    public init(_ components: any CustomStringConvertible..., from service: Service) {
        self.path = components.map { $0.description }.joined(separator: "/")
        self.service = service
    }
    
    public var body: some Request {
        EmptyRequest()
            .path(path)
            .method(.get)
            .service(service)
    }
}
