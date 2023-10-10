//
//  Mock.swift
//
//
//  Created by Piotrek Jeremicz on 11/10/2023.
//

import Foundation

public struct Mock {
    public struct Configuration {
        let responseDelay: TimeInterval
        let resolveAs: Result

        public init(responseDelay: TimeInterval = 0, resolveAs: Result = .none) {
            self.responseDelay = responseDelay
            self.resolveAs = resolveAs
        }

        public enum Result {
            case successfulResponse
            case failedResponse
            case none
        }
    }
}
