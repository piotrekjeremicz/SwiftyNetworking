//
//  ConfigurationValues.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 21.09.2025.
//

import Foundation
import OSLog

public struct ConfigurationValues: Sendable {
    private var storage: [ObjectIdentifier: AnySendable] = [:]
    private var keyNames: [ObjectIdentifier: String] = [:]

    public init() {}

    public subscript<K>(key: K.Type) -> K.Value where K: ConfigurationKey {
        get {
            storage[ObjectIdentifier(key)]?.value as? K.Value ?? K.defaultValue
        }

        set {
            keyNames[ObjectIdentifier(key)] = String(reflecting: key)
            storage[ObjectIdentifier(key)] = AnySendable(newValue)
        }
    }
}

extension ConfigurationValues: CustomDebugStringConvertible {
    public var debugDescription: String {
        let count = storage.count
        guard count > 0 else { return "ConfigurationValues(storage: empty)" }

        var lines: [String] = []
        lines.append("ConfigurationValues(storage: \(count) entr\(count == 1 ? "y" : "ies"))")
        let items: [(String, Any)] = storage.map { (id, value) in
            let name = keyNames[id] ?? "Key(\(String(describing: id)))"
            return (name, value.value)
        }.sorted { $0.0 < $1.0 }

        for (name, value) in items {
            let valueType = String(reflecting: type(of: value))
            let valueDesc = String(reflecting: value)
            lines.append("- \(name): \(valueDesc) (\(valueType))")
        }

        return lines.joined(separator: "\n")
    }
}

private struct AnySendable: @unchecked Sendable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }
}
