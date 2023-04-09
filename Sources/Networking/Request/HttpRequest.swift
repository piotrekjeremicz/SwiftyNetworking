//
//  HttpRequest.swift
//  
//
//  Created by Piotrek Jeremicz on 02/04/2023.
//

import Foundation

public protocol HttpRequest: Request {
    init(configuration: Configuration?)
}

