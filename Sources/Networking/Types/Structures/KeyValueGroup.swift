//
//  Group.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 27.09.2025.
//

import Foundation

fileprivate struct DynamicCodingKey: CodingKey {
    let stringValue: String
    let intValue: Int? = nil
    init?(stringValue: String) { self.stringValue = stringValue }
    init?(intValue: Int) { return nil }
}

public struct KeyValueGroup: ValueBasicType {
    let root: [any KeyValuePair]
    
    public init(@KeyValueBuilder _ root: () -> [any KeyValuePair]) {
        self.root = root()
    }
}

extension KeyValueGroup {
    public var description: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        if let data = try? encoder.encode(self),
           let string = String(data: data, encoding: .utf8) {
            return string
        }
        return "{}"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKey.self)
        for pair in root {
            try pair.encodeValue(into: &container)
        }
    }
}

fileprivate extension KeyValuePair {
    func encodeValue(into container: inout KeyedEncodingContainer<DynamicCodingKey>) throws {
        guard let codingKey = DynamicCodingKey(stringValue: key) else {
            throw EncodingError.invalidValue(key, EncodingError.Context(codingPath: container.codingPath, debugDescription: "Invalid coding key: \(key)"))
        }
        try container.encode(value, forKey: codingKey)
    }
}
