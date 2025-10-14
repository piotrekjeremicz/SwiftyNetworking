//
//  QueryItemsKey.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 22.09.2025.
//

import Foundation

enum QueryItemsKey: ConfigurationKey {
    static let defaultValue: [String: String] = [:]
    typealias Value = [String: String]
}

extension ConfigurationValues {
    var queryItems: [String: String] {
        get { self[QueryItemsKey.self] }
        set { self[QueryItemsKey.self] = newValue }
    }
}
