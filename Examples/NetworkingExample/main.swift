//
//  main.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 20.09.2025.
//

import Networking
import OSLog

// MARK: - Networking Configuration
let session = Session()

// MARK: - GET ToDos Request
await getToDosRequest(session)

// MARK: - POST Add ToDo Request
await addToDoRequest(session)

// MARK: - Authorization Flow
await authorizationFlow(session)

