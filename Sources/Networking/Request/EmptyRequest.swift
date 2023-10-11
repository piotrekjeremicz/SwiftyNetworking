//
//  EmptyRequest.swift
//  
//
//  Created by Piotrek Jeremicz on 02/04/2023.
//

import Foundation

public struct EmptyRequest: Request {

    public var id: UUID = .init()
    
    public typealias ResponseBody = Empty
    public typealias ResponseError = Empty
    
    public var configuration: Configuration?
    public var builder: ResponseBuilder<Empty> = ResponseBuilder()
    public var mock: Empty?

    public init() {
        configuration = nil
    }
}
