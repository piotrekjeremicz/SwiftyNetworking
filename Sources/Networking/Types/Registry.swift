//
//  Registry.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 04.10.2025.
//

import Foundation

internal actor Registry {
    private var requestTypes: [(id: UUID, type: ObjectIdentifier)] = []

    func register(_ request: some Request, with id: UUID) {
        requestTypes.append((id, ObjectIdentifier(type(of: request))))
    }

    func get(by type: any Request.Type) -> [UUID] {
        requestTypes
            .filter { $0.type == ObjectIdentifier(type) }
            .map(\.id)
    }

    func remove(_ id: UUID) {
        requestTypes.removeAll(where: { $0.id == id })
    }
}
