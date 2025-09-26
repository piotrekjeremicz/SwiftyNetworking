//
//  Group.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 27.09.2025.
//

import Foundation

@MainActor
struct KeyValueGroup {
    let root: [any KeyValuePair]
    
    init(@KeyValueBuilder _ root: () -> [any KeyValuePair]) {
        self.root = root()
    }
}

fileprivate struct DynamicCodingKey: CodingKey {
    let stringValue: String
    let intValue: Int? = nil
    init?(stringValue: String) { self.stringValue = stringValue }
    init?(intValue: Int) { return nil }
}

fileprivate extension KeyValuePair {
    // Encodes only the value under its key into the provided keyed container.
    func encodeValue(into container: inout KeyedEncodingContainer<DynamicCodingKey>) throws {
        guard let codingKey = DynamicCodingKey(stringValue: key) else {
            throw EncodingError.invalidValue(key, EncodingError.Context(codingPath: container.codingPath, debugDescription: "Invalid coding key: \(key)"))
        }
        try container.encode(value, forKey: codingKey)
    }
}

extension KeyValueGroup: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKey.self)
        for pair in root {
            try pair.encodeValue(into: &container)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKey.self)
        var items: [any KeyValuePair] = []

        for key in container.allKeys {
            let name = key.stringValue
            // Try to decode in order of most specific/common JSON primitives
            if let value = try? container.decode(String.self, forKey: key) {
                items.append(Key(name, value: value))
                continue
            }
            if let value = try? container.decode(Int.self, forKey: key) {
                items.append(Key(name, value: value))
                continue
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                items.append(Key(name, value: value))
                continue
            }
            if let value = try? container.decode(Bool.self, forKey: key) {
                items.append(Key(name, value: value))
                continue
            }
            if let value = try? container.decode([String].self, forKey: key) {
                items.append(Key(name, value: value))
                continue
            }
            if let value = try? container.decode([Int].self, forKey: key) {
                items.append(Key(name, value: value))
                continue
            }
            if let value = try? container.decode([Double].self, forKey: key) {
                items.append(Key(name, value: value))
                continue
            }
            if let value = try? container.decode([Bool].self, forKey: key) {
                items.append(Key(name, value: value))
                continue
            }

            throw DecodingError.dataCorruptedError(forKey: key, in: container, debugDescription: "Unsupported JSON value for key: \(name)")
        }

        self.root = items
    }
}
