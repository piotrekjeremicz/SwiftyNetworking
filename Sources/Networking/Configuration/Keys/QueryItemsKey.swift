//
//  QueryItemsKey.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 22.09.2025.
//

import Foundation

enum QueryItemsKey: ConfigurationKey {
    static var defaultValue: [URLQueryItem] = []
    typealias Value = [URLQueryItem]
}

extension ConfigurationValues {
    var queryItems: [URLQueryItem] {
        get { self[QueryItemsKey.self] }
        set { self[QueryItemsKey.self] = newValue }
    }
}
