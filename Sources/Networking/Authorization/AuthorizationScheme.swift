//
//  AuthorizationScheme.swift
//  
//
//  Created by Piotrek Jeremicz on 10/05/2023.
//

import Foundation

public enum AuthorizationScheme {
    case basic(username: String, password: String)
    case bearer(token: String)
    
    case raw(scheme: String, token: String)
    
    //TODO: Add another schemes: digest, HOBA, Mutual, Negotiate/NTLM, VAPID, SCRAM, AWS4-HMAC-SHA256
    
    public var token: String {
        switch self {
        case .basic(let username, let password):
            return "BASIC " + (username + ":" + password).data(using: .utf8)!.base64EncodedString()
            
        case .bearer(let token):
            return "BEARER " + token
            
        case .raw(let scheme, let token):
            return scheme.capitalized + " " + token
        }
    }
}
