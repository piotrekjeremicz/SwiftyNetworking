//
//  Service.swift
//  
//
//  Created by Piotrek on 18/06/2022.
//

import Foundation

public protocol Service {
    var baseURL: URL { get }
    var responseDecoder: (any DataDecoder)? { get }
    var bodyEncoder: (any DataEncoder)? { get }
}

public extension Service {
    var responseDecoder: (any DataDecoder)? { nil }
    var bodyEncoder: (any DataEncoder)? { nil }
}
