//
//  File.swift
//  
//
//  Created by Piotrek Jeremicz on 09/05/2023.
//

import Foundation

extension DecodingError {
    public var failureReason: String? {
        switch self {
        case .typeMismatch(_, let context):
            return "Key \(key(from: context.codingPath)) has a wrong type. \(context.debugDescription)"
            
        case .valueNotFound(_, let context):
            return "Key \(key(from: context.codingPath)) can not be associated with a value. \(context.debugDescription)"
            
        case .keyNotFound(_, let context):
            return "Key \(key(from: context.codingPath)) can not be found. \(context.debugDescription)"
            
        case .dataCorrupted(let context):
            return "Data is corupted. \(context.debugDescription)"
            
        @unknown default:
            return "Unknown decoding error."
        }
        
        func key(from codingKeys: [CodingKey]) -> String {
            return codingKeys.map({ $0.stringValue }).joined(separator: ".")
        }
    }
}
