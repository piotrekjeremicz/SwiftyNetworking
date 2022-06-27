//
//  DataCoder.swift
//  
//
//  Created by Piotrek on 27/06/2022.
//

import Foundation

public protocol DataEncoder {
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

public protocol DataDecoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: DataDecoder { }
extension JSONEncoder: DataEncoder { }
