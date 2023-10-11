//
//  Mock.swift
//
//
//  Created by Piotrek Jeremicz on 11/10/2023.
//

import Foundation

public struct Mock {
    public struct Configuration {
        let responseDuration: Duration
        let resolveAs: Result

        public init(responseDelay: Duration = .zero, resolveAs: Result = .none) {
            self.responseDuration = responseDelay
            self.resolveAs = resolveAs
        }

        public enum Result {
            case successfulResponse
            case failedResponse
            case none
        }
    }
}
