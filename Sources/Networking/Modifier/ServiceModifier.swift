//
//  ServiceModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 29.09.2025.
//

public struct ServiceModifier<Content>: RequestModifier where Content: Request {
    let service: Service
    
    public func body(content: Content) -> some Request {
        content.configuration(\.service, value: service)
    }
}

public extension Request {
    func service(_ service: Service) -> some Request {
        modifier(ServiceModifier(service: service))
    }
}
