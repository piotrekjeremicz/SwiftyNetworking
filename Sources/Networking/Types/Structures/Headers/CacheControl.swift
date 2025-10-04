//
//  CacheControl.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 27.09.2025.
//

public struct CacheControl: KeyValuePair {
    public let key: String
    public let value: String

    public init(_ key: String = "Cache-Control", value: String) {
        self.key = key
        self.value = value
    }

    public static let noCache = CacheControl(value: "no-cache")
    public static let noStore = CacheControl(value: "no-store")
    public static func maxAge(_ seconds: Int) -> CacheControl{
        CacheControl(value: "max-age=\(seconds)")
    }
}
