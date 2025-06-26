//
//  ValueBasicType.swift
//  
//
//  Created by Piotrek Jeremicz on 08/04/2023.
//

import Foundation

public protocol ValueBasicType: Codable, CustomStringConvertible, Equatable { }

extension Swift.Int: ValueBasicType { }
extension Swift.Bool: ValueBasicType { }
extension Swift.Double: ValueBasicType { }
extension Swift.String: ValueBasicType { }
extension Swift.Array: ValueBasicType where Element: ValueBasicType { }
