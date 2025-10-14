//
//  Session+Extension.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 29.09.2025.
//

#if canImport(Foundation)
extension Session {
    public init() {
        self.init(provider: URLSessionProvider())
    }
}
#endif
