//
//  PathKey.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 22.09.2025.
//

enum PathKey: ConfigurationKey {
    static let defaultValue: String = ""
    typealias Value = String
}

extension ConfigurationValues {
    var path: String {
        get { self[PathKey.self] }
        set { self[PathKey.self] = newValue }
    }
}
