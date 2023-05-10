//
//  AuthorizationProvider.swift
//  
//
//  Created by Piotrek Jeremicz on 10/05/2023.
//

import Foundation

public protocol AuthorizationProvider {
    func authorize<R: Request>(_ request: R) -> R
    func afterAuthorization()
}
