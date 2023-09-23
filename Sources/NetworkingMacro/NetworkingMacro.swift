// The Swift Programming Language
// https://docs.swift.org/swift-book

import Networking

@attached(member, names: named(ResponseBody), named(ResponseError))
public macro Request() = #externalMacro(module: "NetworkingMacros", type: "RequestMacro")
