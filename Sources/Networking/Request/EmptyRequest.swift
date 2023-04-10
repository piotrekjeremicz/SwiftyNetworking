//
//  EmptyRequest.swift
//  
//
//  Created by Piotrek Jeremicz on 02/04/2023.
//

import Foundation

public struct EmptyRequest: Request {

    public var configuration: Configuration?

    public init() {
        configuration = nil
    }
}
