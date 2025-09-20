//
//  EmptyRequest.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 20.09.2025.
//

struct EmptyRequest: Request {    
    @_spi(Private)
    public var body: Never {
        fatalError("EmptyRequest does not support the `body` property.")
    }
}
