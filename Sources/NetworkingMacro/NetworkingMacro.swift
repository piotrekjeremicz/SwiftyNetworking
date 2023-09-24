// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(member, names: named(ResponseBody), named(ResponseError))
@attached(extension)
public macro Request() = #externalMacro(module: "NetworkingMacros", type: "RequestMacro")
