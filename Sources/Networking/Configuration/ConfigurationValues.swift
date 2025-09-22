//
//  ConfigurationValues.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 21.09.2025.
//

public struct ConfigurationValues {
    private static var storage: [ObjectIdentifier: Any] = [:]
    
    public subscript<K>(key: K.Type) -> K.Value where K: ConfigurationKey {
        get {
            Self.storage[ObjectIdentifier(key)] as? K.Value ?? K.defaultValue
        }
        set {
            Self.storage[ObjectIdentifier(key)] = newValue
        }
    }
}
