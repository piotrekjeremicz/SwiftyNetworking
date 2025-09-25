//
//  Never+Request.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 20.09.2025.
//

extension Never: Request {
    @_spi(Private)
    public var body: Never {
        fatalError("Never does not support the `body` property.")
    }

    @_spi(Private)
    public var configuration: ConfigurationValues? {
        get { fatalError("Never does not support the `configuration` property.") }
        set { fatalError("Never does not support the `configuration` property.") }
    }
}
