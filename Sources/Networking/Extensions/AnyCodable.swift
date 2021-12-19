//
//  AnyCodable.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 19/12/2021.
//

import XMLCoder
import Foundation

public protocol AnyDataEncoder {
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

public protocol AnyDataDecoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: AnyDataDecoder { }
extension JSONEncoder: AnyDataEncoder { }

extension XMLDecoder: AnyDataDecoder { }
extension XMLEncoder: AnyDataEncoder { }
