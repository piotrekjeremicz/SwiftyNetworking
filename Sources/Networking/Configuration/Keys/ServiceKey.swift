//
//  ServiceKey.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 29.09.2025.
//

enum ServiceKey: ConfigurationKey {
    static let defaultValue: (any Service)? = nil
    typealias Value = (any Service)?
}

extension ConfigurationValues {
    var service: (any Service)? {
        get { self[ServiceKey.self] }
        set { self[ServiceKey.self] = newValue }
    }
}
