//
//  Registry.swift
//  
//
//  Created by Piotrek Jeremicz on 22/08/2023.
//

import Foundation

internal actor Registry {
    private var requestTypes: [(id: UUID, type: String)] = []
    
    func register(_ request: some Request) {
        requestTypes.append((request.id, String(describing: request.self)))
    }
    
    func get(by type: any Request.Type) -> [(id: UUID, type: String)] {
        requestTypes.filter({ $0.type == String(describing: type) })
    }
    
    func remove(_ id: String) {
        requestTypes.removeAll(where: { $0.id.uuidString == id })
    }
    
    func remove(_ request: some Request) {
        requestTypes.removeAll(where: { $0.id == request.id })
    }
}
