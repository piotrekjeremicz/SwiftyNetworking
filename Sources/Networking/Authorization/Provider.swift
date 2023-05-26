//
//  Provider.swift
//  
//
//  Created by Piotrek Jeremicz on 10/05/2023.
//

import Foundation

public protocol AuthorizationProvider {
    var store: AuthorizationStore { get }
    var afterAuthorization: ((_ response: Codable, _ store: AuthorizationStore) -> Void)? { get set }
    
    func authorize<R: Request>(_ request: R) -> R
}

public extension AuthorizationProvider {
    //TODO: Finish `KeychainAuthorizationService` as a default `AuthorizationStore`
//    var store: AuthorizationStore { KeychainAuthorizationStore() }
}
