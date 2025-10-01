//
//  Logger.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 28.09.2025.
//

import OSLog

internal let networkingLogger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? ProcessInfo.processInfo.processName,
    category: "networking"
)
