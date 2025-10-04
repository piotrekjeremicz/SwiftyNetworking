//
//  BodyKey.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 22.09.2025.
//

import Foundation

enum BodyKey: ConfigurationKey {
    static let defaultValue: Data? = nil
    typealias Value = Data?
}

extension ConfigurationValues {
    var body: Data? {
        get { self[BodyKey.self] }
        set { self[BodyKey.self] = newValue }
    }
}
