//
//  SessionConfiguration.swift
//
//
//  Created by Piotrek Jeremicz on 10/10/2023.
//

import Foundation

extension Session {
    public struct Configuration {

        public let mock: Mock.Configuration
        public let logging: Bool

        public init(logging: Bool = false, mock: Mock.Configuration = .init()) {
            self.mock = mock
            self.logging = logging
        }
    }
}
